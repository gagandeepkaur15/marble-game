\documentclass[a4paper,12pt]{article}
\usepackage{hyperref}

\title{How to Pull and Run the Marble Game Project}
\author{}
\date{}

\begin{document}

\maketitle

\section*{Prerequisites}
Before you begin, make sure you have the following installed on your laptop:
\begin{itemize}
    \item \textbf{Git} (for cloning the repository)
    \item \textbf{Flutter} (for running the project)
    \item \textbf{An IDE} (e.g., Visual Studio Code, Android Studio)
\end{itemize}

\section*{Steps to Pull and Run the Project}

\subsection*{1. Clone the Repository}
First, open a terminal or Git Bash on your laptop. Then, clone the repository by running the following command:

\begin{verbatim}
git clone https://github.com/gagandeepkaur15/marble-game.git
\end{verbatim}

\subsection*{2. Navigate to the Project Directory}
After cloning the repository, navigate to the project folder:

\begin{verbatim}
cd marble-game
\end{verbatim}

\subsection*{3. Install Flutter Dependencies}
Make sure you have Flutter installed and configured correctly on your machine. To install the required dependencies for the project, run the following command:

\begin{verbatim}
flutter pub get
\end{verbatim}

This will fetch all the necessary packages and dependencies defined in the \texttt{pubspec.yaml} file.

\subsection*{4. Run the Project}
Once the dependencies are installed, you can run the project on an emulator or a connected physical device. To start the game, use the following command:

\begin{verbatim}
flutter run
\end{verbatim}

This will launch the game on the default device.

\subsection*{5. Play the Game}
Now that the app is running, you can start playing the game by:
\begin{itemize}
    \item Dragging marbles to drop them onto the 4x4 game board.
    \item Using the timer to make strategic moves within the given time limit.
    \item Trying to align four marbles in a row to win the game.
\end{itemize}

\section*{Conclusion}
You have successfully pulled, set up, and run the Marble Game project on your laptop. Enjoy playing the game, and feel free to contribute or report any issues!

\end{document}
