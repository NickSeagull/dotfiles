import openai
import sys
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

# Get the OpenAI API key from the .env file
openai.api_key = os.getenv("OPENAI_API_KEY")

SYSTEM_PROMPT = """
    You are a GPT that follows the following description:
    This GPT is an expert note-taking assistant specializing in atomic notes and the methodology from the book 'How to Take Smart Notes' 
    by Sönke Ahrens. It helps users break down large documents into smaller, digestible atomic notes while offering advice on how to 
    begin writing on a specific topic. It emphasizes clarity and simplicity, following the principles of concise, self-contained 
    note creation. It also guides users through linking ideas and expanding upon notes as they grow. Responses focus on creating connections 
    between concepts and generating actionable insights. When users request advice, it should offer step-by-step suggestions based on 
    Ahrens' Zettelkasten method, encouraging writing notes that can later be reused and combined into larger works. It promotes organization
    and encourages users to think deeply about the ideas they are capturing. Use markdown as the format for the output. Use level 1 headings
    for the main title of the different atomic notes, and level 2 headings for the different sections of each note. Add at the end of each note, 
    notes to look for, in order to link this note to the rest of the notes in a zettelkasten with notes about coding, music, magick, philosophy, art,
    software development, and many more.

    Summary of the instructions:

    - Split the text into many atomic notes. Each atomic note should have a title.
    - Each atomic note should have key points as level 2 heading, with a description underneath
    - Each atomic note should have at the end a hint for linking it into the rest of the zettelkasten

    """

def transcribe_audio(file_path):
    try:
        # Extract the basename without extension
        base_name = os.path.splitext(file_path)[0]
        output_file = f"{base_name}.txt"

        # Open the audio file and transcribe it using Whisper
        with open(file_path, 'rb') as audio_file:
            transcript = openai.audio.transcriptions.create(
                model="whisper-1", 
                file=audio_file
            )

        # Save the transcription result to a .txt file with the same basename
        with open(output_file, "w") as transcript_file:
            transcript_file.write(transcript.text)

        print(f"Transcription saved to {output_file}")

        return transcript.text

    except Exception as e:
        print(f"Error during transcription: {e}")
        return None

def summarize_text(text):
    try:
        # Summarize the transcribed text using GPT-4
        response = openai.chat.completions.create(
            model="gpt-4o",
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": f"convert these notes into atomic notes:\n\n{text}"}
            ]
        )

        summary = response.choices[0].message.content

        print("Summary:\n", summary)

        return summary

    except Exception as e:
        print(f"Error during summarization: {e}")
        return None

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python transcribe.py <audio_file.mp3>")
    else:
        # Step 1: Transcribe the audio file
        transcript_text = transcribe_audio(sys.argv[1])

        # Step 2: Summarize the transcription if successful
        if transcript_text:
            summary = summarize_text(transcript_text)
            if summary:
                # Save the summary to a file
                base_name = os.path.splitext(sys.argv[1])[0]
                summary_file = f"{base_name}_summary.txt"
                with open(summary_file, "w") as file:
                    file.write(summary)
                print(f"Summary saved to {summary_file}")

