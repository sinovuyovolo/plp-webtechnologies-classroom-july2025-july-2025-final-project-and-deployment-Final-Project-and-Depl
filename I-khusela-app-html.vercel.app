<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculator</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Chosen Palette: "Calm Neutral" - A mix of slate gray, beige, and soft blues for a professional, calming, and trustworthy feel. Accent color is a muted teal. -->
    <!-- Application Structure Plan: The app uses a dual-layer structure. The first layer is a 'plausible deniability' calculator screen to ensure user privacy. Upon successful 'login' (entering a secret code), the main application is revealed. The main app uses a modern dashboard layout with a fixed sidebar for navigation and a main content area for the interactive modules. This structure was chosen to provide clear, task-oriented separation for each feature (e.g., Chat, Journal, Safety Timer) while keeping critical tools like the SOS button and wellness check-in immediately accessible on the main dashboard. This non-linear, tool-based approach is more user-friendly in a potential crisis than a narrative or report-style layout. -->
    <!-- Visualization & Content Choices: Report Info: User sentiment/wellness. Goal: Track user's emotional state over time. Viz/Presentation: A simple line chart on the main dashboard. Interaction: Displays mock data showing mood fluctuations. Justification: Provides a quick, visual summary of wellbeing patterns for the user. Library: Chart.js. Report Info: Emergency contacts. Goal: Provide quick access to help. Viz/Presentation: A structured list with clear labels and buttons. Interaction: Click-to-call simulation. Justification: Prioritizes clarity and speed in an emergency. Method: HTML/Tailwind. All other features are presented as interactive forms or content blocks to fulfill their specific functions as per the project blueprint. -->
    <!-- CONFIRMATION: NO SVG graphics used. NO Mermaid JS used. -->
    <style>
        body { font-family: 'Inter', sans-serif; }
        .dark {
            --bg-primary: #1f2937; /* gray-800 */
            --bg-secondary: #374151; /* gray-700 */
            --bg-accent: #4b5563; /* gray-600 */
            --text-primary: #f3f4f6; /* gray-100 */
            --text-secondary: #d1d5db; /* gray-300 */
            --border-color: #4b5563; /* gray-600 */
            --accent-color: #14b8a6; /* teal-500 */
        }
        html.dark body { background-color: var(--bg-primary); color: var(--text-primary); }
        .calculator-btn { transition: background-color 0.2s ease-in-out; }
        .nav-item.active { background-color: var(--accent-color); color: white; }
        .chat-bubble-user { background-color: var(--accent-color); color: white; }
        .chat-bubble-ai { background-color: var(--bg-secondary); }
        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 40;
        }
        .modal {
            z-index: 50;
        }
    </style>
</head>
<body class="bg-gray-100">

    <!-- =========== Calculator Lock Screen =========== -->
    <div id="calculator-screen" class="min-h-screen flex items-center justify-center bg-gray-200">
        <div class="w-full max-w-sm mx-auto bg-white shadow-2xl rounded-2xl p-4">
            <div class="bg-gray-800 text-white text-4xl text-right rounded-lg p-4 mb-4 overflow-x-auto" id="calculator-display">0</div>
            <div class="grid grid-cols-4 gap-2">
                <button class="calculator-btn text-2xl bg-gray-300 hover:bg-gray-400 p-4 rounded-lg" onclick="clearDisplay()">C</button>
                <button class="calculator-btn text-2xl bg-gray-300 hover:bg-gray-400 p-4 rounded-lg" onclick="appendInput('(')">(</button>
                <button class="calculator-btn text-2xl bg-gray-300 hover:bg-gray-400 p-4 rounded-lg" onclick="appendInput(')')">)</button>
                <button class="calculator-btn text-2xl bg-yellow-500 hover:bg-yellow-600 text-white p-4 rounded-lg" onclick="appendInput('/')">÷</button>

                <button class="calculator-btn text-2xl bg-gray-200 hover:bg-gray-300 p-4 rounded-lg" onclick="appendInput('7')">7</button>
                <button class="calculator-btn text-2xl bg-gray-200 hover:bg-gray-300 p-4 rounded-lg" onclick="appendInput('8')">8</button>
                <button class="calculator-btn text-2xl bg-gray-200 hover:bg-gray-300 p-4 rounded-lg" onclick="appendInput('9')">9</button>
                <button class="calculator-btn text-2xl bg-yellow-500 hover:bg-yellow-600 text-white p-4 rounded-lg" onclick="appendInput('*')">×</button>

                <button class="calculator-btn text-2xl bg-gray-200 hover:bg-gray-300 p-4 rounded-lg" onclick="appendInput('4')">4</button>
                <button class="calculator-btn text-2xl bg-gray-200 hover:bg-gray-300 p-4 rounded-lg" onclick="appendInput('5')">5</button>
                <button class="calculator-btn text-2xl bg-gray-200 hover:bg-gray-300 p-4 rounded-lg" onclick="appendInput('6')">6</button>
                <button class="calculator-btn text-2xl bg-yellow-500 hover:bg-yellow-600 text-white p-4 rounded-lg" onclick="appendInput('-')">−</button>

                <button class="calculator-btn text-2xl bg-gray-200 hover:bg-gray-300 p-4 rounded-lg" onclick="appendInput('1')">1</button>
                <button class="calculator-btn text-2xl bg-gray-200 hover:bg-gray-300 p-4 rounded-lg" onclick="appendInput('2')">2</button>
                <button class="calculator-btn text-2xl bg-gray-200 hover:bg-gray-300 p-4 rounded-lg" onclick="appendInput('3')">3</button>
                <button class="calculator-btn text-2xl bg-yellow-500 hover:bg-yellow-600 text-white p-4 rounded-lg" onclick="appendInput('+')">+</button>

                <button class="calculator-btn text-2xl bg-gray-200 hover:bg-gray-300 p-4 rounded-lg col-span-2" onclick="appendInput('0')">0</button>
                <button class="calculator-btn text-2xl bg-gray-200 hover:bg-gray-300 p-4 rounded-lg" onclick="appendInput('.')">.</button>
                <button class="calculator-btn text-2xl bg-green-500 hover:bg-green-600 text-white p-4 rounded-lg" onclick="calculateResult()">=</button>
            </div>
        </div>
    </div>

    <!-- =========== Main Application (Initially Hidden) =========== -->
    <div id="main-app" class="hidden dark:bg-bg-primary dark:text-text-primary">
        <div class="flex h-screen bg-gray-100 dark:bg-bg-primary">
            <!-- Sidebar Navigation -->
            <aside class="w-16 md:w-64 bg-white dark:bg-bg-secondary flex flex-col transition-all duration-300">
                <div class="h-16 flex items-center justify-center md:justify-start md:px-4 border-b dark:border-border-color">
                    <span class="text-xl font-bold text-teal-600 dark:text-accent-color">iK</span>
                    <span class="hidden md:inline font-bold text-xl ml-2 dark:text-text-primary">iKhuselo</span>
                </div>
                <nav class="flex-1 mt-6">
                    <a href="#dashboard" class="nav-item flex items-center py-3 px-5 text-gray-700 dark:text-text-secondary hover:bg-gray-200 dark:hover:bg-bg-accent" onclick="switchView('dashboard')">
                        <span class="text-2xl">🏠</span><span class="hidden md:inline ml-4">Dashboard</span>
                    </a>
                    <a href="#contacts" class="nav-item flex items-center py-3 px-5 text-gray-700 dark:text-text-secondary hover:bg-gray-200 dark:hover:bg-bg-accent" onclick="switchView('contacts')">
                        <span class="text-2xl">📞</span><span class="hidden md:inline ml-4">Emergency Contacts</span>
                    </a>
                    <a href="#date-safety" class="nav-item flex items-center py-3 px-5 text-gray-700 dark:text-text-secondary hover:bg-gray-200 dark:hover:bg-bg-accent" onclick="switchView('date-safety')">
                        <span class="text-2xl">❤️</span><span class="hidden md:inline ml-4">On a Date Safety</span>
                    </a>
                    <a href="#journal" class="nav-item flex items-center py-3 px-5 text-gray-700 dark:text-text-secondary hover:bg-gray-200 dark:hover:bg-bg-accent" onclick="switchView('journal')">
                        <span class="text-2xl">📓</span><span class="hidden md:inline ml-4">Private Journal</span>
                    </a>
                    <a href="#sign-language" class="nav-item flex items-center py-3 px-5 text-gray-700 dark:text-text-secondary hover:bg-gray-200 dark:hover:bg-bg-accent" onclick="switchView('sign-language')">
                        <span class="text-2xl">✋</span><span class="hidden md:inline ml-4">Help Signals</span>
                    </a>
                    <a href="#personal-info" class="nav-item flex items-center py-3 px-5 text-gray-700 dark:text-text-secondary hover:bg-gray-200 dark:hover:bg-bg-accent" onclick="switchView('personal-info')">
                        <span class="text-2xl">👤</span><span class="hidden md:inline ml-4">Personal Info</span>
                    </a>
                </nav>
            </aside>

            <!-- Main Content -->
            <main class="flex-1 flex flex-col overflow-hidden">
                <header class="h-16 bg-white dark:bg-bg-secondary flex items-center justify-between px-6 border-b dark:border-border-color">
                    <div class="flex items-center">
                        <h1 id="greeting" class="text-xl font-semibold">Hello, Snow!</h1>
                    </div>
                    <div class="flex items-center space-x-4">
                        <div class="relative">
                            <button id="lang-btn" class="flex items-center space-x-2">
                                <span>🇿🇦</span>
                                <span>EN</span>
                            </button>
                            <div id="lang-menu" class="hidden absolute right-0 mt-2 w-48 bg-white dark:bg-bg-secondary rounded-md shadow-lg py-1 z-20">
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-text-secondary hover:bg-gray-100 dark:hover:bg-bg-accent" data-lang="EN">English</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-text-secondary hover:bg-gray-100 dark:hover:bg-bg-accent" data-lang="ZU">isiZulu</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-text-secondary hover:bg-gray-100 dark:hover:bg-bg-accent" data-lang="XH">isiXhosa</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-text-secondary hover:bg-gray-100 dark:hover:bg-bg-accent" data-lang="AF">Afrikaans</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-text-secondary hover:bg-gray-100 dark:hover:bg-bg-accent" data-lang="NS">Sepedi</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-text-secondary hover:bg-gray-100 dark:hover:bg-bg-accent" data-lang="TN">Setswana</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-text-secondary hover:bg-gray-100 dark:hover:bg-bg-accent" data-lang="ST">Sesotho</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-text-secondary hover:bg-gray-100 dark:hover:bg-bg-accent" data-lang="TS">Xitsonga</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-text-secondary hover:bg-gray-100 dark:hover:bg-bg-accent" data-lang="SS">siSwati</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-text-secondary hover:bg-gray-100 dark:hover:bg-bg-accent" data-lang="VE">Tshivenḓa</a>
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-text-secondary hover:bg-gray-100 dark:hover:bg-bg-accent" data-lang="NR">isiNdebele</a>
                            </div>
                        </div>
                        <button id="theme-toggle" class="text-2xl">🌙</button>
                    </div>
                </header>

                <div class="flex-1 p-6 overflow-y-auto">
                    <!-- Dashboard View -->
                    <div id="view-dashboard" class="app-view">
                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                            <!-- Left Column: Wellness & SOS -->
                            <div class="lg:col-span-2 space-y-6">
                                <div class="p-6 bg-white dark:bg-bg-secondary rounded-lg shadow">
                                    <h2 class="text-lg font-semibold mb-3">How are you feeling today?</h2>
                                    <div class="flex justify-around">
                                        <button class="text-4xl p-4 rounded-full hover:bg-gray-200 dark:hover:bg-bg-accent">😊</button>
                                        <button class="text-4xl p-4 rounded-full hover:bg-gray-200 dark:hover:bg-bg-accent">😟</button>
                                        <button class="text-4xl p-4 rounded-full hover:bg-red-200 dark:hover:bg-red-800" onclick="showModal('sos-confirm')">🆘</button>
                                    </div>
                                </div>
                                <div class="p-6 bg-white dark:bg-bg-secondary rounded-lg shadow text-center">
                                    <h2 class="text-lg font-semibold mb-4">Emergency SOS</h2>
                                    <p class="text-gray-600 dark:text-text-secondary mb-4">Press if you are in immediate danger. This will contact the nearest police and ambulance services.</p>
                                    <button class="bg-red-600 text-white font-bold py-6 px-12 rounded-full text-2xl shadow-lg hover:bg-red-700 transform hover:scale-105 transition-transform" onclick="showModal('sos-confirm')">
                                        SOS
                                    </button>
                                </div>
                                 <div class="p-6 bg-white dark:bg-bg-secondary rounded-lg shadow">
                                    <h2 class="text-lg font-semibold mb-3">Your Wellness Journey</h2>
                                    <div class="chart-container h-64">
                                        <canvas id="wellnessChart"></canvas>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Column: AI Chatbot -->
                            <div class="bg-white dark:bg-bg-secondary rounded-lg shadow flex flex-col h-[75vh]">
                                <div class="p-4 border-b dark:border-border-color">
                                    <h2 class="text-lg font-semibold">AI Assistant</h2>
                                </div>
                                <div id="chat-window" class="flex-1 p-4 overflow-y-auto space-y-4">
                                    <div class="chat-bubble-ai self-start max-w-xs md:max-w-md p-3 rounded-lg">Hello, I'm here to help. Are you in a safe place to talk?</div>
                                </div>
                                <div class="p-4 border-t dark:border-border-color flex">
                                    <input type="text" id="chat-input" placeholder="Type your message..." class="flex-1 p-2 border rounded-l-lg dark:bg-bg-accent dark:border-border-color focus:outline-none focus:ring-2 focus:ring-accent-color">
                                    <button id="chat-send" class="bg-teal-500 dark:bg-accent-color text-white px-4 rounded-r-lg hover:bg-teal-600">Send</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Other Views (hidden by default) -->
                    <div id="view-contacts" class="app-view hidden">
                         <div class="p-6 bg-white dark:bg-bg-secondary rounded-lg shadow">
                            <h2 class="text-2xl font-bold mb-4">Emergency Contacts</h2>
                             <p class="text-gray-600 dark:text-text-secondary mb-6">These are toll-free numbers for essential services in South Africa. Click a button to simulate a call.</p>
                            <div class="space-y-4">
                                <div class="flex items-center justify-between p-4 bg-gray-50 dark:bg-bg-accent rounded-lg">
                                    <div>
                                        <h3 class="font-semibold">SAPS (Police)</h3>
                                        <p class="text-gray-500 dark:text-text-secondary">10111</p>
                                    </div>
                                    <button class="bg-blue-500 text-white font-semibold py-2 px-4 rounded-lg hover:bg-blue-600" onclick="simulateCall('SAPS', '10111')">Call</button>
                                </div>
                                <div class="flex items-center justify-between p-4 bg-gray-50 dark:bg-bg-accent rounded-lg">
                                    <div>
                                        <h3 class="font-semibold">GBV Command Centre</h3>
                                        <p class="text-gray-500 dark:text-text-secondary">0800 150 150</p>
                                    </div>
                                    <button class="bg-purple-500 text-white font-semibold py-2 px-4 rounded-lg hover:bg-purple-600" onclick="simulateCall('GBV Command Centre', '0800 150 150')">Call</button>
                                </div>
                                <div class="flex items-center justify-between p-4 bg-gray-50 dark:bg-bg-accent rounded-lg">
                                    <div>
                                        <h3 class="font-semibold">National Ambulance</h3>
                                        <p class="text-gray-500 dark:text-text-secondary">10177</p>
                                    </div>
                                    <button class="bg-green-500 text-white font-semibold py-2 px-4 rounded-lg hover:bg-green-600" onclick="simulateCall('Ambulance', '10177')">Call</button>
                                </div>
                                <div class="flex items-center justify-between p-4 bg-gray-50 dark:bg-bg-accent rounded-lg">
                                    <div>
                                        <h3 class="font-semibold">Childline SA</h3>
                                        <p class="text-gray-500 dark:text-text-secondary">116</p>
                                    </div>
                                    <button class="bg-yellow-500 text-white font-semibold py-2 px-4 rounded-lg hover:bg-yellow-600" onclick="simulateCall('Childline SA', '116')">Call</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="view-date-safety" class="app-view hidden">
                         <div class="p-6 bg-white dark:bg-bg-secondary rounded-lg shadow max-w-lg mx-auto">
                             <h2 class="text-2xl font-bold mb-4">"On a Date" Safety Timer</h2>
                             <p class="text-gray-600 dark:text-text-secondary mb-6">Fill in the details of your meeting. Set a timer. If you don't check in before it expires, an alert will be simulated as sent to your emergency contacts.</p>
                             <div class="space-y-4">
                                 <input type="text" placeholder="Person's Name" class="w-full p-2 border rounded dark:bg-bg-accent dark:border-border-color">
                                 <input type="text" placeholder="Contact Number" class="w-full p-2 border rounded dark:bg-bg-accent dark:border-border-color">
                                 <input type="text" placeholder="Meeting Location" class="w-full p-2 border rounded dark:bg-bg-accent dark:border-border-color">
                                 <div>
                                    <label class="block text-sm font-medium text-gray-700 dark:text-text-secondary">Upload a picture</label>
                                    <input type="file" class="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-teal-50 file:text-teal-600 hover:file:bg-teal-100 dark:file:bg-accent-color dark:file:text-white"/>
                                 </div>
                                 <div>
                                     <label for="timer-duration" class="block text-sm font-medium text-gray-700 dark:text-text-secondary">Check-in after:</label>
                                     <select id="timer-duration" class="w-full p-2 border rounded dark:bg-bg-accent dark:border-border-color">
                                         <option value="1">1 Hour</option>
                                         <option value="2" selected>2 Hours</option>
                                         <option value="3">3 Hours</option>
                                         <option value="0.1">5 Minutes (Test)</option>
                                     </select>
                                 </div>
                                 <button id="start-timer-btn" class="w-full bg-teal-500 dark:bg-accent-color text-white font-bold py-3 px-4 rounded-lg hover:bg-teal-600">Start Safety Timer</button>
                                 <div id="timer-display" class="hidden text-center">
                                     <p class="text-lg">Time remaining:</p>
                                     <p id="timer-countdown" class="text-2xl font-bold">02:00:00</p>
                                     <button id="cancel-timer-btn" class="mt-2 bg-red-500 text-white font-semibold py-2 px-4 rounded-lg hover:bg-red-600">Cancel Timer</button>
                                 </div>
                             </div>
                         </div>
                    </div>
                    <div id="view-journal" class="app-view hidden">
                        <div class="p-6 bg-white dark:bg-bg-secondary rounded-lg shadow max-w-2xl mx-auto">
                            <h2 class="text-2xl font-bold mb-4">Private Journal</h2>
                             <p class="text-gray-600 dark:text-text-secondary mb-6">Your thoughts are safe here. Each entry is timestamped and stored securely. This can be a useful record if you ever need it.</p>
                            <textarea id="journal-entry" class="w-full h-48 p-2 border rounded dark:bg-bg-accent dark:border-border-color mb-4" placeholder="Write what's on your mind..."></textarea>
                            <button id="save-journal-btn" class="bg-teal-500 dark:bg-accent-color text-white font-bold py-2 px-4 rounded-lg hover:bg-teal-600">Save Entry</button>
                            <div class="mt-8">
                                <h3 class="text-xl font-semibold mb-4">Past Entries</h3>
                                <div id="journal-entries-container" class="space-y-4">
                                    <!-- Mock Entry -->
                                    <div class="p-4 bg-gray-50 dark:bg-bg-accent rounded-lg">
                                        <p class="text-sm text-gray-500 dark:text-text-secondary">August 30, 2025, 5:08 PM</p>
                                        <p>Feeling a bit anxious today after the incident at the market.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="view-sign-language" class="app-view hidden">
                         <div class="p-6 bg-white dark:bg-bg-secondary rounded-lg shadow">
                             <h2 class="text-2xl font-bold mb-4">Help Signals & Emoji Key</h2>
                             <p class="text-gray-600 dark:text-text-secondary mb-6">Use these signals if you cannot speak or type freely. Our AI Assistant is trained to recognize them.</p>
                             <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                 <div>
                                     <h3 class="text-xl font-semibold mb-4">Hand Signal for Help</h3>
                                     <div class="bg-gray-200 dark:bg-bg-accent rounded-lg p-4 text-center">
                                        <div class="text-6xl mb-2">✋</div>
                                        <p class="font-semibold">Signal For Help</p>
                                        <p class="text-sm">1. Palm facing out, thumb tucked in. 2. Fold fingers down over thumb. This is a recognized international signal for distress.</p>
                                     </div>
                                 </div>
                                 <div>
                                     <h3 class="text-xl font-semibold mb-4">Emoji Key</h3>
                                     <ul class="space-y-2">
                                         <li class="flex items-center"><span class="text-2xl mr-4">🚓</span> Police needed</li>
                                         <li class="flex items-center"><span class="text-2xl mr-4">🏥</span> Medical help needed</li>
                                         <li class="flex items-center"><span class="text-2xl mr-4">🔥</span> Immediate danger</li>
                                         <li class="flex items-center"><span class="text-2xl mr-4">🗣️</span> Need someone to talk to</li>
                                         <li class="flex items-center"><span class="text-2xl mr-4">🤫</span> Cannot talk freely</li>
                                     </ul>
                                 </div>
                             </div>
                         </div>
                    </div>
                    <div id="view-personal-info" class="app-view hidden">
                        <div class="p-6 bg-white dark:bg-bg-secondary rounded-lg shadow max-w-lg mx-auto">
                             <h2 class="text-2xl font-bold mb-4">Personal Information</h2>
                            <p class="text-gray-600 dark:text-text-secondary mb-6">Filling this in can save critical time in an emergency. This data is only used to help you when you trigger an SOS.</p>
                             <div class="space-y-4">
                                 <input type="text" placeholder="Full Name (e.g., Snow Doe)" class="w-full p-2 border rounded dark:bg-bg-accent dark:border-border-color">
                                 <input type="number" placeholder="Age" class="w-full p-2 border rounded dark:bg-bg-accent dark:border-border-color">
                                 <input type="text" placeholder="Full Address" class="w-full p-2 border rounded dark:bg-bg-accent dark:border-border-color">
                                 <input type="text" placeholder="Known Allergies" class="w-full p-2 border rounded dark:bg-bg-accent dark:border-border-color">
                                 <input type="text" placeholder="Blood Type" class="w-full p-2 border rounded dark:bg-bg-accent dark:border-border-color">
                                 <h3 class="font-semibold pt-4">Emergency Contacts</h3>
                                 <input type="text" placeholder="Contact 1 Name & Number" class="w-full p-2 border rounded dark:bg-bg-accent dark:border-border-color">
                                 <input type="text" placeholder="Contact 2 Name & Number" class="w-full p-2 border rounded dark:bg-bg-accent dark:border-border-color">
                                 <button class="w-full bg-teal-500 dark:bg-accent-color text-white font-bold py-3 px-4 rounded-lg hover:bg-teal-600">Save Information</button>
                             </div>
                        </div>
                    </div>

                </div>
            </main>
        </div>
    </div>
    
    <!-- Modals -->
    <div id="sos-confirm-modal" class="modal-backdrop hidden items-center justify-center">
        <div class="modal bg-white dark:bg-bg-secondary rounded-lg shadow-xl p-6 max-w-sm mx-auto text-center">
            <h3 class="text-xl font-bold mb-4">Confirm SOS</h3>
            <p class="text-gray-600 dark:text-text-secondary mb-6">Are you sure? This action will immediately contact police and medical services with your location and information.</p>
            <div class="flex justify-center space-x-4">
                <button class="bg-gray-300 dark:bg-bg-accent py-2 px-6 rounded-lg hover:bg-gray-400" onclick="hideModal('sos-confirm')">Cancel</button>
                <button class="bg-red-600 text-white font-bold py-2 px-6 rounded-lg hover:bg-red-700" onclick="triggerSOS()">Confirm</button>
            </div>
        </div>
    </div>
    
    <div id="alert-modal" class="modal-backdrop hidden items-center justify-center">
        <div class="modal bg-white dark:bg-bg-secondary rounded-lg shadow-xl p-6 max-w-sm mx-auto text-center">
            <h3 id="alert-title" class="text-xl font-bold mb-4">Alert</h3>
            <p id="alert-message" class="text-gray-600 dark:text-text-secondary mb-6">Message here.</p>
            <button class="bg-teal-500 dark:bg-accent-color text-white font-bold py-2 px-6 rounded-lg hover:bg-teal-600" onclick="hideModal('alert')">OK</button>
        </div>
    </div>


<script>
    // --- State Management ---
    let calculatorInput = '';
    const SECRET_CODE = '1234';
    let currentView = 'dashboard';
    let dateSafetyTimer;
    let journalEntries = [{
        date: 'August 30, 2025, 5:08 PM',
        text: 'Feeling a bit anxious today after the incident at the market.'
    }];
    
    // --- DOM Elements ---
    const calculatorDisplay = document.getElementById('calculator-display');
    const calculatorScreen = document.getElementById('calculator-screen');
    const mainApp = document.getElementById('main-app');
    const themeToggle = document.getElementById('theme-toggle');
    const langBtn = document.getElementById('lang-btn');
    const langMenu = document.getElementById('lang-menu');

    // --- Calculator Logic ---
    function appendInput(value) {
        if (calculatorInput === '0' && value !== '.') {
            calculatorInput = '';
        }
        calculatorInput += value;
        updateDisplay();
    }

    function clearDisplay() {
        calculatorInput = '0';
        updateDisplay();
    }

    function updateDisplay() {
        calculatorDisplay.textContent = calculatorInput || '0';
    }

    function calculateResult() {
        if (calculatorInput === SECRET_CODE) {
            unlockApp();
            return;
        }
        try {
            // Replace visual operators with functional ones
            let evalInput = calculatorInput.replace(/×/g, '*').replace(/÷/g, '/');
            const result = eval(evalInput);
            calculatorInput = String(result);
            updateDisplay();
        } catch (error) {
            calculatorInput = 'Error';
            updateDisplay();
            setTimeout(() => {
               clearDisplay();
            }, 1500);
        }
    }
    
    function unlockApp() {
        calculatorScreen.classList.add('hidden');
        mainApp.classList.remove('hidden');
        mainApp.classList.add('flex');
        // Initialize the active nav item
        document.querySelector('.nav-item').classList.add('active');
        initializeWellnessChart();
    }
    
    // --- Main App Logic ---
    function switchView(viewId) {
        document.querySelectorAll('.app-view').forEach(view => {
            view.classList.add('hidden');
        });
        document.getElementById(`view-${viewId}`).classList.remove('hidden');
        
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.remove('active', 'bg-teal-500', 'text-white', 'dark:bg-accent-color');
            if (item.getAttribute('href') === `#${viewId}`) {
                item.classList.add('active', 'bg-teal-500', 'text-white', 'dark:bg-accent-color');
            }
        });
        currentView = viewId;
    }

    // --- Theme Switcher ---
    themeToggle.addEventListener('click', () => {
        const html = document.documentElement;
        html.classList.toggle('dark');
        if (html.classList.contains('dark')) {
            themeToggle.textContent = '☀️';
            localStorage.setItem('theme', 'dark');
        } else {
            themeToggle.textContent = '🌙';
            localStorage.setItem('theme', 'light');
        }
    });

    // --- Language Switcher ---
    langBtn.addEventListener('click', () => {
        langMenu.classList.toggle('hidden');
    });

    document.addEventListener('click', (e) => {
        if (!langBtn.contains(e.target) && !langMenu.contains(e.target)) {
            langMenu.classList.add('hidden');
        }
    });
    
    langMenu.addEventListener('click', (e) => {
        if (e.target.tagName === 'A') {
            const lang = e.target.dataset.lang;
            document.querySelector('#lang-btn span:last-child').textContent = lang;
            langMenu.classList.add('hidden');
            // Mock translation
            showAlert('Language Switched', `The app language has been set to ${e.target.textContent}. (This is a demo).`);
        }
    });

    // --- AI Chatbot ---
    const chatWindow = document.getElementById('chat-window');
    const chatInput = document.getElementById('chat-input');
    const chatSendBtn = document.getElementById('chat-send');
    
    const sendChatMessage = () => {
        const message = chatInput.value.trim();
        if (!message) return;

        // Add user message
        const userBubble = document.createElement('div');
        userBubble.className = 'chat-bubble-user self-end max-w-xs md:max-w-md p-3 rounded-lg break-words';
        userBubble.textContent = message;
        chatWindow.appendChild(userBubble);
        
        chatInput.value = '';
        chatWindow.scrollTop = chatWindow.scrollHeight;

        // Simulate AI response
        setTimeout(() => {
            let aiResponse = "I'm sorry, I'm just a demo. How else can I pretend to help you?";
            if (message.toLowerCase().includes("danger") || message.includes("🆘") || message.includes("🔥")) {
                aiResponse = "I detect you are in danger. I am simulating an alert to the authorities. A report is being generated from our conversation. Help is on the way (ETA: 8 minutes). Please stay as safe as you can. Can you tell me more about your location?";
            } else if (message.toLowerCase().includes("talk") || message.includes("🗣️")) {
                 aiResponse = "Of course. I am here to listen. Please tell me what's on your mind. Remember, this is a safe space.";
            }
            const aiBubble = document.createElement('div');
            aiBubble.className = 'chat-bubble-ai self-start max-w-xs md:max-w-md p-3 rounded-lg break-words';
            aiBubble.textContent = aiResponse;
            chatWindow.appendChild(aiBubble);
            chatWindow.scrollTop = chatWindow.scrollHeight;
        }, 1000);
    };

    chatSendBtn.addEventListener('click', sendChatMessage);
    chatInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            sendChatMessage();
        }
    });
    
    // --- Modals ---
    function showModal(modalId) {
        document.getElementById(`${modalId}-modal`).classList.remove('hidden');
        document.getElementById(`${modalId}-modal`).classList.add('flex');
    }

    function hideModal(modalId) {
        document.getElementById(`${modalId}-modal`).classList.add('hidden');
        document.getElementById(`${modalId}-modal`).classList.remove('flex');
    }
    
    function showAlert(title, message) {
        document.getElementById('alert-title').textContent = title;
        document.getElementById('alert-message').textContent = message;
        showModal('alert');
    }
    
    // --- SOS Logic ---
    function triggerSOS() {
        hideModal('sos-confirm');
        showAlert('SOS Activated', 'Emergency services have been dispatched to your saved address. ETA: 8 minutes. Stay on the line with the AI assistant if possible.');
    }
    
    function simulateCall(service, number) {
        showAlert('Simulating Call', `Calling ${service} at ${number}... (This is a demo).`);
    }

    // --- Date Safety Timer ---
    const startTimerBtn = document.getElementById('start-timer-btn');
    const timerDisplay = document.getElementById('timer-display');
    const timerCountdown = document.getElementById('timer-countdown');
    const cancelTimerBtn = document.getElementById('cancel-timer-btn');

    startTimerBtn.addEventListener('click', () => {
        const durationHours = parseFloat(document.getElementById('timer-duration').value);
        let durationSeconds = durationHours * 3600;

        startTimerBtn.classList.add('hidden');
        timerDisplay.classList.remove('hidden');

        dateSafetyTimer = setInterval(() => {
            durationSeconds--;
            const hours = Math.floor(durationSeconds / 3600);
            const minutes = Math.floor((durationSeconds % 3600) / 60);
            const seconds = durationSeconds % 60;

            timerCountdown.textContent = 
                `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
            
            if (durationSeconds <= 0) {
                clearInterval(dateSafetyTimer);
                timerCountdown.textContent = "EXPIRED";
                showAlert('Safety Timer Expired', 'An alert with your location and date details has been simulated as sent to your emergency contacts.');
            }
        }, 1000);
    });
    
    cancelTimerBtn.addEventListener('click', () => {
        clearInterval(dateSafetyTimer);
        startTimerBtn.classList.remove('hidden');
        timerDisplay.classList.add('hidden');
        showAlert('Timer Cancelled', 'Your safety timer has been successfully cancelled.');
    });

    // --- Journal Logic ---
    const saveJournalBtn = document.getElementById('save-journal-btn');
    const journalEntryInput = document.getElementById('journal-entry');
    const journalContainer = document.getElementById('journal-entries-container');
    
    function renderJournal() {
        journalContainer.innerHTML = '';
        [...journalEntries].reverse().forEach(entry => {
            const entryDiv = document.createElement('div');
            entryDiv.className = 'p-4 bg-gray-50 dark:bg-bg-accent rounded-lg';
            entryDiv.innerHTML = `<p class="text-sm text-gray-500 dark:text-text-secondary">${entry.date}</p><p>${entry.text}</p>`;
            journalContainer.appendChild(entryDiv);
        });
    }

    saveJournalBtn.addEventListener('click', () => {
        const text = journalEntryInput.value.trim();
        if (!text) return;
        
        const now = new Date();
        const entry = {
            date: now.toLocaleString('en-ZA'),
            text: text
        };
        journalEntries.push(entry);
        journalEntryInput.value = '';
        renderJournal();
        showAlert('Entry Saved', 'Your journal entry has been securely saved.');
    });
    
    // --- Wellness Chart ---
    let wellnessChart;
    function initializeWellnessChart() {
        if(wellnessChart) {
            wellnessChart.destroy();
        }
        const ctx = document.getElementById('wellnessChart').getContext('2d');
        wellnessChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Mood Level (1=Uneasy, 2=Okay, 3=Safe)',
                    data: [2, 3, 2, 1, 3, 3, 2], // Mock data
                    borderColor: 'rgb(20, 184, 166)', // teal-500
                    backgroundColor: 'rgba(20, 184, 166, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 4,
                        ticks: {
                           stepSize: 1,
                            callback: function(value) {
                                if (value === 1) return 'Uneasy';
                                if (value === 2) return 'Okay';
                                if (value === 3) return 'Safe';
                                return '';
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    }


    // --- On Load ---
    document.addEventListener('DOMContentLoaded', () => {
        // Check for saved theme
        if (localStorage.getItem('theme') === 'dark' || 
           (window.matchMedia('(prefers-color-scheme: dark)').matches && !localStorage.getItem('theme'))) {
            document.documentElement.classList.add('dark');
            themeToggle.textContent = '☀️';
        }
        renderJournal();
        switchView('dashboard');
    });

</script>

</body>
</html>


