import React, { useEffect, useState } from 'react';
import './App.css';
import { fetchNui } from '../utils/fetchNui';
import Collapsible from './Collapsible'; // Import your Collapsible component

interface Lobby {
    ID: number;
    custom?: boolean;
    playerCount: number;
    settings: {
        name: string;
        recoilMode: string;
        tags?: string[];
        firstPersonVehicle: boolean;
        hsMulti: boolean;
        spawningcars?: boolean;
        RandomSpawns?: { x: number; y: number; z: number; h: number }[];
        maxPlayers: number;
        passwordProtected: boolean;
        password?: string;
    }
}

const App: React.FC = () => {
    const [lobbies, setLobbies] = useState<Lobby[]>([]);
    const [passwordInput, setPasswordInput] = useState('');
    const [showPasswordPrompt, setShowPasswordPrompt] = useState(false);
    const [selectedLobby, setSelectedLobby] = useState<Lobby | null>(null);
    const [tab, setTab] = useState<'Normal' | 'Custom'>('Normal');
    const [showCustomLobbyPrompt, setShowCustomLobbyPrompt] = useState(false);
    const [showCreateText, setShowCreateText] = useState(false)
    const [customLobbySettings, setCustomLobbySettings] = useState<{
        name: string;
        maxPlayers: number;
        recoilMode: string;
        firstPersonVehicle: boolean;
        hsMulti: boolean;
        passwordProtected: boolean;
        password?: string;
        nonstopcombat: boolean;
        onlyInSafezone: boolean;
        disableHighRoofs: boolean;
        disableLadders: boolean;
        disableQPeeking: boolean;
        disableFP: boolean;
        skeletons: boolean;
    }>({
        maxPlayers: 12,
        name: '',
        recoilMode: 'roleplay',
        firstPersonVehicle: false,
        hsMulti: false,
        passwordProtected: false,
        password: '',
        nonstopcombat: false,
        onlyInSafezone: false,
        disableHighRoofs: false,
        disableLadders: false,
        disableQPeeking: false,
        disableFP: false,
        skeletons: false,
    });

    const handleUpdateLobbies = (event: MessageEvent) => {
        if (event.data.type === 'updateLobbies') {
            const receivedLobbies: Lobby[] = event.data.lobbies;

            setLobbies(prevLobbies => {
                const updatedLobbies = receivedLobbies.map((receivedLobby: Lobby) => {
                    const existingLobbyIndex = prevLobbies.findIndex(lobby => lobby.ID === receivedLobby.ID);

                    if (existingLobbyIndex !== -1) {
                        return {
                            ...prevLobbies[existingLobbyIndex],
                            custom: receivedLobby.custom,
                            name: receivedLobby.settings.name,
                            settings: receivedLobby.settings,
                        };
                    } else {
                        return {
                            ...receivedLobby,
                            custom: receivedLobby.custom,
                        };
                    }
                });
                return updatedLobbies;
            });
        }
    };

    const handlePlayerCountUpdate = (event: MessageEvent) => {
        if (event.data.type === 'updatePlayerCount') {
            const newPlayerCount = event.data.count;
            const worldID = event.data.worldId;

            setLobbies(prevLobbies => {
                return prevLobbies.map((lobby) => {
                    if (lobby.ID === worldID) {
                        return { ...lobby, playerCount: newPlayerCount };
                    }
                    return lobby;
                });
            });
        }
    };

    const handleJoinLobby = (lobbyId: number) => {
        const lobby = lobbies.find(lobby => lobby.ID === lobbyId);
        if (lobby && lobby.settings.passwordProtected) {
            setSelectedLobby(lobby);
            setShowPasswordPrompt(true);
        } else {
            joinLobby(lobbyId, '');
        }
    };

    const joinLobby = (lobbyId: number, password: string) => {
        fetchNui('switchWorld', { worldId: lobbyId, password })
            .then((response) => {
                if (!response.success) {
                    console.error('Failed to join the lobby:', response.error);
                }
            })
            .catch((error) => {
                console.error('Failed to join the lobby:', error);
            });
    };

    const handlePasswordInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setPasswordInput(e.target.value);
    };

    const handlePasswordSubmit = () => {
        if (selectedLobby) {
            if (passwordInput.trim() === selectedLobby.settings.password) {
                joinLobby(selectedLobby.ID, passwordInput);
                setShowPasswordPrompt(false);
                setPasswordInput('');
                setSelectedLobby(null);
            } else {
                setShowPasswordPrompt(false);
                setPasswordInput('');
                setSelectedLobby(null);
            }
        }
    };

    const handleCancel = () => {
        setShowPasswordPrompt(false);
        setPasswordInput('');
        setSelectedLobby(null);
    };

    const handleCreateCustomLobby = () => {
        fetchNui('createCustomLobby', customLobbySettings)
            .then(response => {
                if (response.success) {
                    /* console.log('Custom lobby created successfully!'); */

                } else {
                    console.error('Failed to create custom lobby:', response.error);

                }
            })
            .catch(error => {
                console.error('Error creating custom lobby:', error);

            });
        setShowCustomLobbyPrompt(false);
    };

    useEffect(() => {
        window.addEventListener('message', handleUpdateLobbies);
        return () => {
            window.removeEventListener('message', handleUpdateLobbies);
        };
    }, []);

    useEffect(() => {
        window.addEventListener('message', handlePlayerCountUpdate);
        return () => {
            window.removeEventListener('message', handlePlayerCountUpdate);
        };
    }, []);

    useEffect(() => {
        const handleMessage = (event: MessageEvent) => {
            if (event.data.type === 'closeCustomLobbyPrompt') {
                setShowCustomLobbyPrompt(false);
            }
        };

        window.addEventListener('message', handleMessage);

        return () => {
            window.removeEventListener('message', handleMessage);
        };
    }, []);

    useEffect(() => {
        const handleMessage = (event: MessageEvent) => {
            if (event.data.type === 'closePasswordPrompt') {
                setShowPasswordPrompt(false);
                setPasswordInput('');
                setSelectedLobby(null);
            }
        };

        window.addEventListener('message', handleMessage);

        return () => {
            window.removeEventListener('message', handleMessage);
        };
    }, []);

    const handlePasswordChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const newPassword = e.target.value;
        setCustomLobbySettings({
            ...customLobbySettings,
            password: newPassword,
            passwordProtected: newPassword !== '' // Update passwordProtected based on password value
        });
    };

    const playClickSound = () => {
        const clickSound = document.getElementById('clickSound') as HTMLAudioElement;
        if (clickSound) {
            clickSound.currentTime = 0;
            clickSound.play();
        }
    }

    const lobbys = tab === 'Normal' ? lobbies.filter(lobby => !lobby.custom) : lobbies.filter(lobby => lobby.custom);

    return (
        <div className='overlay'>
            <audio id="clickSound" src="click_sound.mp3"></audio>
            <div className="menu-container">
                <div className="menu-container-header">
                    <button className={`header-title-play ${tab === 'Normal' ? 'active' : ''}`} onClick={() => {
                        setTab('Normal')
                        setShowCustomLobbyPrompt(false);
                        playClickSound();
                    }
                    }><h1>NORMAL</h1></button>

                    <button className={`header-title-custom ${tab === 'Custom' ? 'active' : ''}`}
                        onClick={() => {
                            setTab('Custom');
                            setShowCustomLobbyPrompt(false);
                            playClickSound();
                        }
                        }><h1 style={{ position: 'absolute', marginLeft: '3vh' }}>CUSTOM</h1></button>

                    <button className={`header-create ${tab === 'Normal' ? 'hide' : ''}`}
                        onClick={() => {
                            setShowCustomLobbyPrompt(true)
                            playClickSound();
                        }}
                        onMouseEnter={() => {
                            if (tab !== 'Normal') {
                                setShowCreateText(true);
                            }
                        }}
                        onMouseLeave={() => setShowCreateText(false)}
                    ><p>+</p></button>
                    <span className="fade-in-text" style={{ display: showCreateText ? 'flex' : 'none' }}>Create Lobby</span>
                </div>

                <div className="customlobby-content" style={{ display: showCustomLobbyPrompt ? 'flex' : 'none' }}>
                    <div className="customlobby-container">
                        <div className="customlobby-title">
                            <h1>SETTINGS</h1>
                        </div>

                        <div className="customlobby-settings">
                            <Collapsible title="General" content={
                                <>
                                    <div className="setting">
                                        <div className="setting-info">
                                            <h1>FPS in Vehicles</h1>
                                        </div>
                                        <div className="setting-check">
                                            <label className="toggleSwitch nolabel">
                                                <input type="checkbox" checked={customLobbySettings.firstPersonVehicle} onChange={(e) => {
                                                    const isChecked = e.target.checked;
                                                    setCustomLobbySettings({
                                                        ...customLobbySettings,
                                                        firstPersonVehicle: isChecked,
                                                        disableFP: isChecked ? false : customLobbySettings.disableFP,
                                                    });
                                                    playClickSound();
                                                }} />
                                                <span>
                                                </span>
                                                <a></a>
                                            </label>
                                        </div>
                                    </div>

                                    <div className="setting">
                                        <div className="setting-info">
                                            <h1>Headshot Multiplier</h1>
                                        </div>
                                        <div className="setting-check">
                                            <label className="toggleSwitch nolabel">
                                                <input type="checkbox" checked={customLobbySettings.hsMulti} onChange={(e) => {
                                                    setCustomLobbySettings({ ...customLobbySettings, hsMulti: e.target.checked });
                                                    playClickSound();
                                                }} />
                                                <span>
                                                </span>
                                                <a></a>
                                            </label>
                                        </div>
                                    </div>

                                    <div className="setting">
                                        <div className="setting-info">
                                            <h1>Only spawn cars in safezone</h1>
                                        </div>
                                        <div className="setting-check">
                                            <label className="toggleSwitch nolabel">
                                                <input type="checkbox" checked={customLobbySettings.onlyInSafezone} onChange={(e) => {
                                                    setCustomLobbySettings({ ...customLobbySettings, onlyInSafezone: e.target.checked })
                                                    playClickSound();
                                                }
                                                } />
                                                <span>
                                                </span>
                                                <a></a>
                                            </label>
                                        </div>
                                    </div>
                                </>
                            } />

                            <Collapsible title="Disable" content={
                                <>
                                    <div className="setting">
                                        <div className="setting-info">
                                            <h1>Disable Roofs</h1>
                                        </div>
                                        <div className="setting-check">
                                            <label className="toggleSwitch nolabel">
                                                <input type="checkbox" checked={customLobbySettings.disableHighRoofs} onChange={(e) => {
                                                    setCustomLobbySettings({ ...customLobbySettings, disableHighRoofs: e.target.checked })
                                                    playClickSound();
                                                }
                                                } />
                                                <span>
                                                </span>
                                                <a></a>
                                            </label>
                                        </div>
                                    </div>

                                    <div className="setting">
                                        <div className="setting-info">
                                            <h1>Disable Ladders</h1>
                                        </div>
                                        <div className="setting-check">
                                            <label className="toggleSwitch nolabel">
                                                <input type="checkbox" checked={customLobbySettings.disableLadders} onChange={(e) => {
                                                    setCustomLobbySettings({ ...customLobbySettings, disableLadders: e.target.checked })
                                                    playClickSound();
                                                }
                                                } />
                                                <span>
                                                </span>
                                                <a></a>
                                            </label>
                                        </div>
                                    </div>

                                    <div className="setting">
                                        <div className="setting-info">
                                            <h1>Disable Q Peeking</h1>
                                        </div>
                                        <div className="setting-check">
                                            <label className="toggleSwitch nolabel">
                                                <input type="checkbox" checked={customLobbySettings.disableQPeeking} onChange={(e) => {
                                                    setCustomLobbySettings({ ...customLobbySettings, disableQPeeking: e.target.checked })
                                                    playClickSound();
                                                }
                                                } />
                                                <span>
                                                </span>
                                                <a></a>
                                            </label>
                                        </div>
                                    </div>

                                    <div className="setting">
                                        <div className="setting-info">
                                            <h1>Disable First Person</h1>
                                        </div>
                                        <div className="setting-check">
                                            <label className="toggleSwitch nolabel">
                                                <input type="checkbox" checked={customLobbySettings.disableFP} onChange={(e) => {
                                                    const isChecked = e.target.checked;
                                                    setCustomLobbySettings({
                                                        ...customLobbySettings,
                                                        firstPersonVehicle: isChecked ? false : customLobbySettings.firstPersonVehicle,
                                                        disableFP: isChecked
                                                    });
                                                    playClickSound();
                                                }
                                                } />
                                                <span>
                                                </span>
                                                <a></a>
                                            </label>
                                        </div>
                                    </div>

                                </>
                            } />

                            <Collapsible title="Other" content={
                                <>
                                    <div className="setting">
                                        <div className="setting-info">
                                            <h1>Overtime Combat</h1>
                                        </div>
                                        <div className="setting-check">
                                            <label className="toggleSwitch nolabel">
                                                <input type="checkbox" checked={customLobbySettings.nonstopcombat} onChange={(e) => {
                                                    setCustomLobbySettings({ ...customLobbySettings, nonstopcombat: e.target.checked })
                                                    playClickSound();
                                                }
                                                } />
                                                <span>
                                                </span>
                                                <a></a>
                                            </label>
                                        </div>
                                    </div>

                                    <div className="setting">
                                        <div className="setting-info">
                                            <h1>ESP</h1>
                                        </div>
                                        <div className="setting-check">
                                            <label className="toggleSwitch nolabel">
                                                <input type="checkbox" checked={customLobbySettings.skeletons} onChange={(e) => {
                                                    setCustomLobbySettings({ ...customLobbySettings, skeletons: e.target.checked })
                                                    playClickSound();
                                                }
                                                } />
                                                <span>
                                                </span>
                                                <a></a>
                                            </label>
                                        </div>
                                    </div>
                                </>
                            } />

                            <div className="setting" style={{ height: '20%', width: '36.82vh' }}>
                                <div className="setting-info">
                                    <h1>Recoil</h1>
                                </div>
                                <div className="setting-check" style={{ marginRight: '3vh' }}>
                                    <select value={customLobbySettings.recoilMode} onChange={(e) => {
                                        setCustomLobbySettings({ ...customLobbySettings, recoilMode: e.target.value })
                                        playClickSound();
                                    }
                                    } >
                                        <option value="envy">Envy</option>
                                        <option value="roleplay">RP Preset #1</option>
                                        <option value="roleplay2">RP Preset #2</option>
                                        <option value="roleplay3">Rena</option>
                                        <option value="nonstop">Overtime</option>
                                        <option value="hardcore">Nopickle</option>
                                        <option value="pma">AMP</option>
                                        <option value="qb">QB</option>
                                    </select>
                                </div>
                            </div>

                            <div className="createlobby">
                                <button className="setting-button" onClick={() => {
                                    handleCreateCustomLobby()
                                    playClickSound();
                                }
                                }><p>Create Lobby</p></button>
                            </div>

                            <div className="password-input-container" style={{padding: '0 0 1vh 0'}}>
                                <input
                                    type="password"
                                    value={customLobbySettings.password}
                                    onChange={handlePasswordChange}
                                    placeholder="Enter Password"
                                    className="password-input"
                                    maxLength={6}
                                />
                            </div>

                        </div>
                    </div>
                </div>
                {/* onClick={() => handleJoinLobby(lobby.ID)} */}
                <div className="lobby-container" style={{ display: showCustomLobbyPrompt ? 'none' : 'flex' }}>
                    <div className="lobby-list">
                        {lobbys.map((lobby) => (
                            <div key={lobby.ID} className="lobby-item">
                                <div className="lobby-firstsections">
                                    <div className="firstsections-content">
                                        <h1>{lobby.settings.name}</h1>

                                        <p>{lobby.playerCount} / {lobby.settings.maxPlayers}</p>
                                        <p>{lobby.settings.tags?.join(', ')}</p>
                                    </div>
                                </div>

                                <button className="lobby-secondsections" onClick={() => {

                                    handleJoinLobby(lobby.ID)
                                    playClickSound();
                                }
                                }>
                                    <p>JOIN</p>
                                </button>

                            </div>
                        ))}

                    </div>

                </div>
            </div>
            {showPasswordPrompt && (
                <div className="modal-background">
                    <div className="password-prompt">
                        <div className="password-input-container">
                            <input
                                type="password"
                                value={passwordInput}
                                onChange={handlePasswordInputChange}
                                placeholder="Enter Password"
                                maxLength={6}
                                className="password-input"
                            />
                        </div>
                        <div className="button-container">
                            <button onClick={() => {
                                playClickSound();
                                handleCancel()
                            }}>Cancel</button>
                            <button onClick={() => {
                                playClickSound();
                                handlePasswordSubmit()
                            }
                            }>Submit</button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default App;