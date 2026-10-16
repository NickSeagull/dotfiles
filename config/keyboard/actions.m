#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>

// One persistent helper preserves a snapshot throughout a held window layer.
// It runs only in the signed-in user's session. No Apple Events/System Events.
static NSArray<NSNumber *> *appOrder;
static NSMutableDictionary<NSNumber *, NSArray *> *windowOrders;
static NSMutableDictionary<NSNumber *, NSNumber *> *windowPositions;
static NSInteger appPosition;
static NSMutableArray *testWindows;

static id axValue(AXUIElementRef element, CFStringRef attribute) {
    CFTypeRef value = NULL;
    if (AXUIElementCopyAttributeValue(element, attribute, &value) != kAXErrorSuccess) return nil;
    return CFBridgingRelease(value);
}

static void snapshot(void) {
    NSMutableArray *pids = [NSMutableArray array];
    NSArray *windows = CFBridgingRelease(CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID));
    NSWorkspace *workspace = NSWorkspace.sharedWorkspace;
    for (NSDictionary *window in windows) {
        NSNumber *pid = window[(id)kCGWindowOwnerPID];
        NSRunningApplication *app = [NSRunningApplication runningApplicationWithProcessIdentifier:pid.intValue];
        if ([window[(id)kCGWindowLayer] intValue] == 0 && app.activationPolicy == NSApplicationActivationPolicyRegular && ![pids containsObject:pid]) [pids addObject:pid];
    }
    for (NSRunningApplication *app in workspace.runningApplications) {
        NSNumber *pid = @(app.processIdentifier);
        if (app.activationPolicy == NSApplicationActivationPolicyRegular && ![pids containsObject:pid]) [pids addObject:pid];
    }
    NSNumber *front = @(workspace.frontmostApplication.processIdentifier);
    if ([pids containsObject:front]) { [pids removeObject:front]; [pids insertObject:front atIndex:0]; }
    appOrder = [pids copy]; appPosition = 0;
    windowOrders = [NSMutableDictionary dictionary]; windowPositions = [NSMutableDictionary dictionary];
    for (NSNumber *pid in appOrder) {
        AXUIElementRef app = AXUIElementCreateApplication(pid.intValue);
        AXUIElementSetMessagingTimeout(app, 1.0);
        NSArray *items = axValue(app, kAXWindowsAttribute) ?: @[];
        id focused = axValue(app, kAXFocusedWindowAttribute);
        NSMutableArray *ordered = [items mutableCopy];
        if (focused && [ordered containsObject:focused]) { [ordered removeObject:focused]; [ordered insertObject:focused atIndex:0]; }
        windowOrders[pid] = ordered;
        windowPositions[pid] = @0;
        CFRelease(app);
    }
}

static NSDictionary *perform(NSDictionary *request) {
    NSString *command = request[@"command"];
    if ([command isEqual:@"request-permissions"]) {
        NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
        return @{@"accessibility": (AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options) ? @YES : @NO)};
    }
    if ([command isEqual:@"permissions"]) return @{@"accessibility": (AXIsProcessTrusted() ? @YES : @NO)};
    if ([command isEqual:@"probe"]) {
        return @{@"accessibility": (AXIsProcessTrusted() ? @YES : @NO), @"bundle": NSWorkspace.sharedWorkspace.frontmostApplication.bundleIdentifier ?: @""};
    }
    if ([command isEqual:@"resolve"]) {
        NSURL *url = [NSWorkspace.sharedWorkspace URLForApplicationWithBundleIdentifier:request[@"bundle"]];
        return url ? @{@"path": url.path} : @{@"error": @"app bundle not installed"};
    }
    if ([command isEqual:@"begin"]) { snapshot(); return @{@"apps": @(appOrder.count)}; }
    if ([command isEqual:@"end"]) { appOrder = nil; windowOrders = nil; windowPositions = nil; return @{@"ok": @YES}; }
    if ([command isEqual:@"launch"]) {
        NSString *bundle = request[@"bundle"];
        for (NSRunningApplication *app in NSWorkspace.sharedWorkspace.runningApplications) {
            if ([app.bundleIdentifier isEqual:bundle]) {
                BOOL ok = [app activateWithOptions:NSApplicationActivateIgnoringOtherApps];
                return ok ? @{@"ok": @YES} : @{@"error": @"app activation failed"};
            }
        }
        NSURL *url = [NSWorkspace.sharedWorkspace URLForApplicationWithBundleIdentifier:bundle];
        if (!url) return @{@"error": @"app bundle not installed"};
        NSWorkspaceOpenConfiguration *configuration = NSWorkspaceOpenConfiguration.configuration;
        configuration.activates = YES;
        // LaunchServices owns startup after this request. A slow first launch
        // must not block the runner's health checks or keyboard emergency stop.
        [NSWorkspace.sharedWorkspace openApplicationAtURL:url configuration:configuration completionHandler:nil];
        return @{@"ok": @YES, @"launchRequested": @YES};
    }
    if ([command isEqual:@"app.next"] || [command isEqual:@"app.previous"]) {
        if (!appOrder) return @{@"error": @"window layer session missing"};
        NSInteger direction = [command hasSuffix:@"next"] ? 1 : -1;
        for (NSUInteger attempt = 0; attempt < appOrder.count; attempt++) {
            appPosition = (appPosition + direction + appOrder.count) % appOrder.count;
            NSRunningApplication *app = [NSRunningApplication runningApplicationWithProcessIdentifier:appOrder[appPosition].intValue];
            if (app && [app activateWithOptions:NSApplicationActivateIgnoringOtherApps]) return @{@"ok": @YES, @"pid": @(app.processIdentifier)};
        }
        return @{@"error": @"no app available in session snapshot"};
    }
    if ([command isEqual:@"window.next"] || [command isEqual:@"window.previous"]) {
        if (!AXIsProcessTrusted()) return @{@"error": @"Accessibility permission required"};
        NSNumber *pid = @(NSWorkspace.sharedWorkspace.frontmostApplication.processIdentifier);
        NSArray *windows = windowOrders[pid];
        if (!windows.count) return @{@"error": @"no windows in session snapshot"};
        NSInteger direction = [command hasSuffix:@"next"] ? 1 : -1;
        NSInteger position = (windowPositions[pid].integerValue + direction + windows.count) % windows.count;
        windowPositions[pid] = @(position);
        AXUIElementRef window = (__bridge AXUIElementRef)windows[position];
        AXError raised = AXUIElementPerformAction(window, kAXRaiseAction);
        AXUIElementSetAttributeValue(window, kAXMainAttribute, kCFBooleanTrue);
        return raised == kAXErrorSuccess ? @{@"ok": @YES, @"index": @(position)} : @{@"error": @"window raise failed"};
    }
    // Self-contained scratch windows let the agent exercise native AX cycling
    // without typing into or closing the user's documents.
    if ([command isEqual:@"scratch"]) {
        [NSApplication.sharedApplication setActivationPolicy:NSApplicationActivationPolicyRegular];
        testWindows = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(120 + i*40, 160 + i*40, 360, 200) styleMask:NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
            window.title = [NSString stringWithFormat:@"Keyboard verification %d", i];
            NSTextView *text = [[NSTextView alloc] initWithFrame:window.contentView.bounds];
            text.string = @"alpha beta gamma\nsecond line\nthird line\n";
            window.contentView = text; [window makeKeyAndOrderFront:nil];
            [testWindows addObject:window];
        }
        [NSApplication.sharedApplication activateIgnoringOtherApps:YES];
        return @{@"ok": @YES};
    }
    return @{@"error": @"unknown action"};
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        [NSApplication sharedApplication];
        char *line = NULL; size_t capacity = 0;
        while (getline(&line, &capacity, stdin) > 0) {
            @autoreleasepool {
                NSData *data = [[NSString stringWithUTF8String:line] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *request = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                NSDictionary *response = request && [request isKindOfClass:NSDictionary.class] ? perform(request) : @{@"error": @"invalid request"};
                NSData *result = [NSJSONSerialization dataWithJSONObject:response options:0 error:&error];
                fwrite(result.bytes, 1, result.length, stdout); fputc('\n', stdout); fflush(stdout);
                [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
            }
        }
        free(line);
    }
    return 0;
}
