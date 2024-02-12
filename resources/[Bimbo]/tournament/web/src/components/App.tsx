import React from 'react';
import './App.css';
import { debugData } from '../utils/debugData';
import { fetchNui } from '../utils/fetchNui';
const { useState, useEffect } = React;

const scoreContainerClass = "Score-Container";
const scoreClass = "Score";
const teamScoreClass = "Score-teamScore";
const gameInformationClass = "Score-gameInformation";
const timerClass = "Score-Timer";
const backdropClass = "Score-backdrop";
const lowTimerClass = "Score-lowTimer";

const App: React.FC = () => {

    const [RANKED_GAME_DATA, setRankedGameData] = useState<{
        red: {
            score: number;
            alive: number;
            players: string[]; // Assuming players' profile picture URLs are stored as strings
        };
        blue: {
            score: number;
            alive: number;
            players: string[]; // Assuming players' profile picture URLs are stored as strings
        };
        timer: string;
        currentTeam: string;
    }>({
        red: {
            score: 0,
            alive: 0,
            players: [] // Initialize the players array with an empty array
        },
        blue: {
            score: 0,
            alive: 0,
            players: [] // Initialize the players array with an empty array
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
                <div className={gameInformationClass}>
                    <div className={`${timerClass} ${minutes < 1 && lowTimerClass}`} style={{ color: minutes < 1 ? "red" : undefined, textShadow: minutes < 1 ? "0px 0px 2px #4f0101" : undefined, background: minutes < 1 ? "radial-gradient(45% 50% at 50% 50%, rgb(79 1 1 / 65%) 0px, rgba(52, 52, 52, 0.7) 93%)" : "radial-gradient(45% 50% at 50% 50%,#d5bfbf38 0,#343434b3 93%)" }}>{RANKED_GAME_DATA.timer}
                    </div>
                </div>
                <div className={scoreClass}>
                    <div className={teamScoreClass} style={{ backgroundColor: "#908aff66", clipPath: "polygon(0 0, 89% 0, 98% 100%, 0 100%)" }}>
                        {Array.from({ length: 4 }).map((_, index) => {
                            const playerUrl = RANKED_GAME_DATA.red.players.reverse()[index] || "https://cdn.forums.klei.com/monthly_2020_01/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg.269696d99af4a73e886c0731e7ed7c16.jpg"
                            return (
                                <div key={index} className={backdropClass}>
                                    <img
                                        src={playerUrl}
                                    />
                                </div>
                            );
                        })}

                        <div className="Score-aliveCount left">{RANKED_GAME_DATA.red.score}</div>
                    </div>
                    <div className={teamScoreClass} style={{ backgroundColor: "#47aeda66", clipPath: "polygon(100% 0, 11% 0, 2% 100%, 100% 100%)" }}>
                        <div className="Score-aliveCount right">{RANKED_GAME_DATA.blue.score}</div>
                        {Array.from({ length: 4 }).map((_, index) => {
                            const playerUrl = RANKED_GAME_DATA.blue.players[index] || "https://cdn.forums.klei.com/monthly_2020_01/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg.269696d99af4a73e886c0731e7ed7c16.jpg"
                            ; // Replace 'placeholder.jpg' with your placeholder image URL
                            return (
                                <div key={index} className={backdropClass}>
                                    <img
                                        src={playerUrl}
                                    />
                                </div>
                            );
                        })}
                    </div>
                </div>
            </div >
        );
    }

    return (
        <div className="nui-wrapper">
            <Score />
        </div>
    );
}

export default App;
