# AI4I – Contribute

AI4I – Contribute is an open-source application designed to make it easy for people to help build multilingual datasets across Indian languages. The app enables users to contribute speech and text data through simple, guided tasks. It currently supports four contribution modules:

- **BOLO** - Voice narration and validation
- **SUNO** – Speech transcription and validation  
- **LIKHO** – Text translation and validation 
- **DEKHO** – Image transcription and validaion  

---

## Features

### BOLO – Voice Narration

#### Contribute
- Read the given text prompt in the selected language.
- Speak clearly what the prompt says.
- Skip unclear prompts or report inappropriate content.
- View a progress summary after completing 5 prompts.

#### Validate
- Review a text prompt along with its audio clip.
- Mark the audio as **Correct** or **Needs Change**.
- Record new audi when corrections are required.
- Skip if unsure and view a summary after each batch of 25.

---

### SUNO – Speech Transcription

#### Transcribe
- Listen to short audio clips.
- Type what you hear in the selected language.
- Skip unclear clips or report inappropriate content.
- View a progress summary after completing 5 clips.

#### Validate
- Review an audio clip along with its transcription.
- Mark the transcription as **Correct** or **Needs Change**.
- Edit text when corrections are required.
- Skip if unsure and view a summary after each batch of 25.

---

### LIKHO – Text Translation

#### Translate
- Choose source and target languages.
- Read the provided sentence.
- Enter the translation in the chosen language.
- Skip or report problems.
- View a summary after every 5 translations.

#### Validate
- Compare a source sentence with its translated version.
- Mark it as **Correct** or **Needs Change**.
- Edit the translation when needed.
- Skip if unsure and view summary updates after each batch of 25.

---

### DEKHO – Image Transcription

#### Transcribe
- Choose the languages.
- Read the provided image.
- Enter the transcription in the chosen language.
- Skip or report problems.
- View a summary after every 5 transcriptions.

#### Validate
- Compare text in image with its transcription.
- Mark it as **Correct** or **Needs Change**.
- Edit the transcription when needed.
- Skip if unsure and view summary updates after each batch of 25.

---

## Who Can Contribute

AI4I – Contribute is designed for anyone familiar with one or more Indian languages, including:

- Teachers  
- Language enthusiasts  
- Students  
- Volunteers  
- Community members  

No technical knowledge is required, and tasks are easy to follow.

---

## Why This App Matters

India’s rich linguistic diversity requires strong datasets so that future AI systems can understand and serve all languages effectively.  
Your contributions help improve:

- Speech recognition  
- Machine translation  
- Text understanding  
- Digital services across Indian languages  

---

## How to Use

1. Open the app and select **BOLO** **SUNO** **LIKHO** or **DEKHO**.  
2. Choose your language(s).
3. Follow the task displayed on-screen.  
4. After every set of 5 tasks, review your contribution summary.  
5. Continue contributing at your own pace.

---

## Project Structure

```
analysis_options.yaml
android/
assets/
backend/
branding.yaml
BRANDING_GUIDE.md
build_scripts/
contracts/
devtools_options.yaml
documentation/
ios/
l10n.yaml
lib/
LICENSE
pubspec.yaml
README.md
test/
tool/
web/
```

---

## Dependencies

Key packages used in the project include:

- UI & layout: flutter_svg, google_fonts, flutter_screenutil, lottie, animations
- Audio handling: just_audio, audioplayers, record
- Permissions: permission_handler
- Networking & storage: http, flutter_secure_storage, shared_preferences
- State management: provider
- Configuration & utilities: flutter_dotenv, encrypt, path, yaml, url_launcher
- Localization: flutter_localizations, intl

---

## Setup

### Install Dependencies

```
flutter pub get
```

### Environment Variables

Create a `.env` file at the project root and add:

```
API_BASE_URL=http://example.com/docs
```

### Run the App

```
flutter run
```

### Run mock backend

```
cd backend
pip install -r requirements.txt
python run.py
```
---