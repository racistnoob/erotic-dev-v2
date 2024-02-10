import React from 'react';
import './App.css';
import { debugData } from '../utils/debugData';
import { fetchNui } from '../utils/fetchNui';
const { useState, useEffect } = React;

const HomeRounded = () => {
    return (
        <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        fill="currentColor"
        stroke="none"
    >                <path d="M10 19v-5h4v5c0 .55.45 1 1 1h3c.55 0 1-.45 1-1v-7h1.7c.46 0 .68-.57.33-.87L12.67 3.6c-.38-.34-.96-.34-1.34 0l-8.36 7.53c-.34.3-.13.87.33.87H5v7c0 .55.45 1 1 1h3c.55 0 1-.45 1-1z" />
        </svg>
    );
};

const Person4Rounded = () => {
    return (
        <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        fill="currentColor"
        stroke="none"
    >                <path d="M18.39 14.56C16.71 13.7 14.53 13 12 13s-4.71.7-6.39 1.56C4.61 15.07 4 16.1 4 17.22V18c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2v-.78c0-1.12-.61-2.15-1.61-2.66zM12 12c2.21 0 4-1.79 4-4V4.5c0-.83-.67-1.5-1.5-1.5-.52 0-.98.27-1.25.67-.27-.4-.73-.67-1.25-.67s-.98.27-1.25.67c-.27-.4-.73-.67-1.25-.67C8.67 3 8 3.67 8 4.5V8c0 2.21 1.79 4 4 4z" />
        </svg>
    );
};

const QuestionMarkRounded = () => (
    <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        fill="currentColor"
        stroke="none"
    >
        <path d="M7.92 7.54c-.8-.34-1.14-1.33-.66-2.05C8.23 4.05 9.85 3 11.99 3c2.35 0 3.96 1.07 4.78 2.41.7 1.15 1.11 3.3.03 4.9-1.2 1.77-2.35 2.31-2.97 3.45-.15.27-.24.49-.3.94-.09.73-.69 1.3-1.43 1.3-.87 0-1.58-.75-1.48-1.62.06-.51.18-1.04.46-1.54.77-1.39 2.25-2.21 3.11-3.44.91-1.29.4-3.7-2.18-3.7-1.17 0-1.93.61-2.4 1.34-.35.57-1.08.75-1.69.5zM14 20c0 1.1-.9 2-2 2s-2-.9-2-2 .9-2 2-2 2 .9 2 2z" />
    </svg>
);

const scoreContainerClass = "Score-Container";
const scoreClass = "Score";
const teamScoreClass = "Score-teamScore";
const gameInformationClass = "Score-gameInformation";
const timerClass = "Score-Timer";
const scoreContainerClass2 = "Score-Container2";
const redScoreClass = "Score-redScore";
const blueScoreClass = "Score-blueScore";
const aliveCountClass = "Score-aliveCount";
const aliveTextClass = "Score-aliveText";
const backdropClass = "Score-backdrop";
const lowTimerClass = "Score-lowTimer";

const App: React.FC = () => {

    const [RANKED_GAME_DATA, setRankedGameData] = useState<{
        red: {
            score: number;
            alive: number;
        };
        blue: {
            score: number;
            alive: number;
        };
        timer: string;
        currentTeam: string;
    }>({
        red: {
            score: 0,
            alive: 0,
        },
        blue: {
            score: 0,
            alive: 0,
        },
        timer: "15:00",
        currentTeam: "",
    });

    const rankedGameDataUpdate = (event: MessageEvent) => {
        if (event.data.type === 'setRankedGameData') {
            setRankedGameData(event.data.payload)
        }
    };

    useEffect(() => {
        window.addEventListener('message', rankedGameDataUpdate);
        return () => {
            window.removeEventListener('message', rankedGameDataUpdate);
        };
    }, []);

    function Score() {
        const scale = 1.0;
        const [minutes, setMinutes] = useState<number>(parseInt(RANKED_GAME_DATA.timer.split(":")[0]));
        const [seconds, setSeconds] = useState<number>(parseInt(RANKED_GAME_DATA.timer.split(":")[1]));
    
        useEffect(() => {
            setMinutes(parseInt(RANKED_GAME_DATA.timer.split(":")[0]));
            setSeconds(parseInt(RANKED_GAME_DATA.timer.split(":")[1]));
        }, [RANKED_GAME_DATA]);
    
        return (
            <div className={scoreContainerClass} style={{ transform: `scale(${Math.min(scale, 1.7) || 1})`, transformOrigin: "top center" }}>
                <div className={scoreClass}>
                    <div className={teamScoreClass} style={{ backgroundColor: "rgb(255, 50, 50)" }}>
                        <div className={backdropClass}>
    
                            {RANKED_GAME_DATA.currentTeam === "red" && (
                                <div style={{ fontSize: "48px", color: "rgba(0,0,0,0.4)" }}>
                                    <HomeRounded />
                                </div>
                            )}
    
                            {RANKED_GAME_DATA.currentTeam === "blue" && (
                                <div style={{ fontSize: "48px", color: "rgba(0,0,0,0.4)" }}>
                                    <Person4Rounded />
                                </div>
                            )}
    
                            {RANKED_GAME_DATA.currentTeam === "" && (
                                <div style={{ fontSize: "48px", color: "rgba(0,0,0,0.4)" }}>
                                    <QuestionMarkRounded />
                                </div>
                            )}
                        </div>
                        <div className={aliveCountClass}>{RANKED_GAME_DATA.red.alive}</div>
                        <div className={aliveTextClass}>ALIVE</div>
                    </div>
                    <div className={gameInformationClass}>
                        <div className={`${timerClass} ${minutes < 1 && lowTimerClass}`} style={{ color: minutes < 1 ? "red" : undefined, textShadow: minutes < 1 ? "0px 0px 2px #4f0101" : undefined }}>{RANKED_GAME_DATA.timer}</div>
                        <div className={scoreContainerClass2}>
                            <div className={redScoreClass} style={{ color: "rgb(255, 50, 50)" }}>{RANKED_GAME_DATA.red.score}</div>
                            <div className={blueScoreClass} style={{ color: "rgb(0, 150, 255)" }}>{RANKED_GAME_DATA.blue.score}</div>
                        </div>
                    </div>
                    <div className={teamScoreClass} style={{ backgroundColor: "rgb(0, 150, 255)" }}>
                        <div className={backdropClass}>
                            {RANKED_GAME_DATA.currentTeam === "blue" && (
                                <div style={{ fontSize: "48px", color: "rgba(0,0,0,0.4)" }}>
                                    <HomeRounded />
                                </div>
                            )}
    
                            {RANKED_GAME_DATA.currentTeam === "red" && (
                                <div style={{ fontSize: "48px", color: "rgba(0,0,0,0.4)" }}>
                                    <Person4Rounded />
                                </div>
                            )}
    
                            {RANKED_GAME_DATA.currentTeam === "" && (
                                <div style={{ fontSize: "48px", color: "rgba(0,0,0,0.4)" }}>
                                    <QuestionMarkRounded />
                                </div>
                            )}
                        </div>
                        <div className={aliveCountClass}>{RANKED_GAME_DATA.blue.alive}</div>
                        <div className={aliveTextClass}>ALIVE</div>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="nui-wrapper">
            <Score/>
        </div>
    );
}

export default App;
