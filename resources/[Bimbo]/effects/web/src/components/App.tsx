import React, { useState, useEffect } from "react";
import "./App.css";
import { debugData } from "../utils/debugData";
import { fetchNui } from "../utils/fetchNui";

// This will set the NUI to visible if we are
// developing in browser
debugData([
  {
    action: "setVisible",
    data: true,
  },
]);

interface Setting {
  name?: string;
  value: string | number;
}

enum Category {
  Effects,
  Time,
  Timecycles,
  Weather
}

const App: React.FC = () => {
  const [effects, setEffects] = useState<Setting[]>([]);
  const [selectedEffectIndex, setSelectedEffectIndex] = useState<number>(0);

  const [times, setTimes] = useState<number[]>([]);
  const [selectedTimeIndex, setSelectedTimeIndex] = useState<number>(0);

  const [timecycles, setTimecycles] = useState<Setting[]>([]);
  const [selectedTimecycleIndex, setSelectedTimecycleIndex] = useState<number>(0);

  const [weathers, setWeathers] = useState<Setting[]>([]);
  const [selectedWeatherIndex, setSelectedWeatherIndex] = useState<number>(0);

  const [selectedCategory, setSelectedCategory] = useState<Category>(Category.Effects);

  const [isLeftArrowPressed, setIsLeftArrowPressed] = useState(false);
  const [isRightArrowPressed, setIsRightArrowPressed] = useState(false);

  const fetchDataFromLua = async () => {
    try {
      // Fetch data for effects, times, timecycles, and weathers from Lua
      const effectResponse = await fetchNui<{ [key: string]: string }>("getBloodFx");
      const timeSettingsResponse = await fetchNui<number[]>("getTimeSettings");
      const timecycleResponse = await fetchNui<{ [key: string]: string }>("getTimecycleSettings");
      const weatherResponse = await fetchNui<{ [key: string]: string }>("getWeatherSettings");

      // Fetch Current User Data Here
      const currentTimeResponse = await fetchNui<number>("getCurrentTimeSettings");

      // @@TODO
      // const currenteffectResponse = await fetchNui<string>("getCurrentEffectSettings");
      // const currenttimecycleResponse = await fetchNui<string>("getTimecycleSettings");
      // const currentweatherResponse = await fetchNui<string>("getCurrentWeatherIndex");
      // setSelectedTimecycleIndex(currenttimecycleResponse)
      // setSelectedWeatherIndex(currentweatherResponse)
      // setSelectedEffectIndex(currenteffectResponse)

      setSelectedTimecycleIndex(0)
      setSelectedWeatherIndex(1)
      setSelectedEffectIndex(4)
      setSelectedTimeIndex(currentTimeResponse)
      // Update state with fetched data
      const effectArray = Object.entries(effectResponse).map(([name, value]) => ({ name, value }));
      setEffects(effectArray);
  
      setTimes(timeSettingsResponse);
  
      const timecycleArray = Object.entries(timecycleResponse).map(([name, value]) => ({ name, value }));
      setTimecycles(timecycleArray);
  
      const weatherArray = Object.entries(weatherResponse).map(([name, value]) => ({ name, value }));
      setWeathers(weatherArray);
  
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  };

  useEffect(() => {
    fetchDataFromLua();

    window.addEventListener("message", handleMessage);

    return () => {
      window.removeEventListener("message", handleMessage);
    };
  }, []);

  const handleMessage = (event: MessageEvent) => {
    const message = event.data;
    if (message.type === "updateTime") {
      const newTime = message.time;
      setSelectedTimeIndex(newTime);
    }
  };

  const handleTimeChange = (hour: number) => {
    fetchNui("effects:setTime", { hour });
  };
  
  const handleBloodFXChange = (name: string) => {
    fetchNui("blood:changeEffect", { effectName: name });
  };

  const handleTimecycleChange = (type: string) => {
    fetchNui("timecycle:changeEffect", { type });
  };

  const handleWeatherChange = (type: string) => {
    fetchNui("weather:changeEffect", { type });
  };

  const handleKeyDown = (event: KeyboardEvent) => {
    const { key } = event;
    const timeItems = document.querySelectorAll('.settings-item-selected');
  
    switch (key) {
      case "ArrowLeft":
        setIsLeftArrowPressed(true);
        setIsRightArrowPressed(false);
        if (selectedCategory === Category.Effects) {
          setSelectedEffectIndex((prevIndex) => {
            const newIndex = prevIndex === 0 ? effects.length - 1 : prevIndex - 1;
            handleBloodFXChange(effects[newIndex]?.name ?? '');
            return newIndex;
          });
        } else if (selectedCategory === Category.Time) {
          setSelectedTimeIndex((prevIndex) => {
            const newIndex = prevIndex === 0 ? times.length - 1 : prevIndex - 1;
            handleTimeChange(times[newIndex]);
            return newIndex;
          });
        } else if (selectedCategory === Category.Timecycles) {
          setSelectedTimecycleIndex((prevIndex) => {
            const newIndex = prevIndex === 0 ? timecycles.length - 1 : prevIndex - 1;
            handleTimecycleChange(timecycles[newIndex]?.name ?? '');
            return newIndex;
          });
        } else if (selectedCategory === Category.Weather) {
          setSelectedWeatherIndex((prevIndex) => {
            const newIndex = prevIndex === 0 ? weathers.length - 1 : prevIndex - 1;
            handleWeatherChange(weathers[newIndex]?.name ?? '');
            return newIndex;
          });
        }
        break;
      case "ArrowRight":
        setIsLeftArrowPressed(false);
        setIsRightArrowPressed(true);
        if (selectedCategory === Category.Effects) {
          setSelectedEffectIndex((prevIndex) => {
            const newIndex = prevIndex === effects.length - 1 ? 0 : prevIndex + 1;
            handleBloodFXChange(effects[newIndex]?.name ?? '');
            return newIndex;
          });
        } else if (selectedCategory === Category.Time) {
          setSelectedTimeIndex((prevIndex) => {
            const newIndex = prevIndex === times.length - 1 ? 0 : prevIndex + 1;
            handleTimeChange(times[newIndex]);
            return newIndex;
          });
        } else if (selectedCategory === Category.Timecycles) {
          setSelectedTimecycleIndex((prevIndex) => {
            const newIndex = prevIndex === timecycles.length - 1 ? 0 : prevIndex + 1;
            handleTimecycleChange(timecycles[newIndex]?.name ?? '');
            return newIndex;
          });
        } else if (selectedCategory === Category.Weather) {
          setSelectedWeatherIndex((prevIndex) => {
            const newIndex = prevIndex === weathers.length - 1 ? 0 : prevIndex + 1;
            handleWeatherChange(weathers[newIndex]?.name ?? '');
            return newIndex;
          });
        }
        break;
      case "ArrowUp":
        setIsLeftArrowPressed(false);
        setIsRightArrowPressed(false);
        setSelectedCategory((prevCategory) => {
          switch (prevCategory) {
            case Category.Effects:
              return Category.Weather;
            case Category.Time:
              return Category.Effects;
            case Category.Timecycles:
              return Category.Time;
            case Category.Weather:
              return Category.Timecycles;
            default:
              return prevCategory;
          }
        });
        break;
      case "ArrowDown":
        setIsLeftArrowPressed(false);
        setIsRightArrowPressed(false);
        setSelectedCategory((prevCategory) => {
          switch (prevCategory) {
            case Category.Effects:
              return Category.Time;
            case Category.Time:
              return Category.Timecycles;
            case Category.Timecycles:
              return Category.Weather;
            case Category.Weather:
              return Category.Effects;
            default:
              return prevCategory;
          }
        });
        break;
      default:
        break;
    }
  
    timeItems.forEach((item, index) => {
      if (item.classList.contains('selected')) {
        setSelectedTimeIndex(index);
      }
    });
  };

  const handleKeyUp = (event: KeyboardEvent) => {
    const { key } = event;
    if (key === "ArrowLeft") {
      setIsLeftArrowPressed(false);
    } else if (key === "ArrowRight") {
      setIsRightArrowPressed(false);
    }
  };

  useEffect(() => {
    document.addEventListener("keydown", handleKeyDown);
    document.addEventListener("keyup", handleKeyUp);
  
    return () => {
      document.removeEventListener("keydown", handleKeyDown);
      document.removeEventListener("keyup", handleKeyUp);
    };
  }, [selectedCategory, selectedEffectIndex, selectedTimeIndex]);

  return (
    <div className="settings-menu">
      <h1 className="settings-header">Graphics Settings</h1>
      {/* <h2 className="settings-header-tooltip">EroticRP</h2> */}
      <div className={`settings-item ${selectedCategory === Category.Effects ? 'active-item' : ''}`}>
      {selectedCategory === Category.Effects && (
        <div
        className={`settings-item-arrow-left ${
          isLeftArrowPressed ? "active" : ""
        } ${isLeftArrowPressed ? "fade-out" : ""}`}
      >
        &#9664;
      </div>
      )}
      <div
        className={`settings-category ${
          selectedCategory === Category.Effects ? "active" : ""
        }`}
      >
        <div className="settings-item-title">BloodFX</div>
        <div
          className={`settings-item-label ${
            selectedCategory === Category.Effects ? "active" : ""
          }`}
        >
          <div
            className={`settings-item-selected ${
              selectedCategory === Category.Effects ? "active" : ""
            }`}
            onClick={() =>
              handleBloodFXChange(effects[selectedEffectIndex]?.name ?? "")
            }
          >
            {effects[selectedEffectIndex]?.name}
          </div>
        </div>
      </div>
      {selectedCategory === Category.Effects && (
        <div
          className={`settings-item-arrow-right ${
            isRightArrowPressed ? "active" : ""
          } ${isRightArrowPressed ? "fade-out" : ""}`}
        >
          &#9654;
        </div>
      )}
    </div>
    <div className={`settings-item ${selectedCategory === Category.Time ? 'active-item' : ''}`}>
      {selectedCategory === Category.Time && (
        <div
          className={`settings-item-arrow-left ${
            isLeftArrowPressed ? "active" : ""
          }`}
        >
          &#9664;
        </div>
      )}
      <div className={`settings-category ${selectedCategory === Category.Time ? 'active' : ''}`}>
        <div className="settings-item-title">Time</div>
        <div className="settings-item-label">
          <div
            className={`settings-item-selected ${
              selectedCategory === Category.Time ? 'active' : ''
            }`}
            onClick={() => handleTimeChange(times[selectedTimeIndex])}
          >
            {times[selectedTimeIndex]}
          </div>
        </div>
      </div>
      {selectedCategory === Category.Time && (
        <div
          className={`settings-item-arrow-right ${
            isRightArrowPressed ? "active" : ""
          }`}
        >
          &#9654;
        </div>
      )}
    </div>
    <div className={`settings-item ${selectedCategory === Category.Timecycles ? 'active-item' : ''}`}>
      {selectedCategory === Category.Timecycles && (
        <div
          className={`settings-item-arrow-left ${
            isLeftArrowPressed ? "active" : ""
          }`}
        >
          &#9664;
        </div>
      )}
      <div className={`settings-category ${selectedCategory === Category.Timecycles ? 'active' : ''}`}>
        <div className="settings-item-title">TimeCycles</div>
        <div className="settings-item-label">
          <div
            className={`settings-item-selected ${
              selectedCategory === Category.Timecycles ? 'active' : ''
            }`}
            onClick={() =>
              handleTimecycleChange(timecycles[selectedTimecycleIndex]?.name ?? '')
            }
          >
            {timecycles[selectedTimecycleIndex]?.name}
          </div>
        </div>
      </div>
      {selectedCategory === Category.Timecycles && (
        <div
          className={`settings-item-arrow-right ${
            isRightArrowPressed ? "active" : ""
          }`}
        >
          &#9654;
        </div>
      )}
    </div>
    <div className={`settings-item ${selectedCategory === Category.Weather ? 'active-item' : ''}`}>
        {selectedCategory === Category.Weather && (
          <div
            className={`settings-item-arrow-left ${
              isLeftArrowPressed ? "active" : ""
            }`}
          >
            &#9664;
          </div>
        )}
        <div className={`settings-category ${selectedCategory === Category.Weather ? 'active' : ''}`}>
          <div className="settings-item-title">Weather</div>
          <div className="settings-item-label">
            <div
              className={`settings-item-selected ${
                selectedCategory === Category.Weather ? 'active' : ''
              }`}
              onClick={() => handleWeatherChange(weathers[selectedWeatherIndex]?.name ?? '')}
            >
              {weathers[selectedWeatherIndex]?.name}
            </div>
          </div>
        </div>
        {selectedCategory === Category.Weather && (
          <div
            className={`settings-item-arrow-right ${
              isRightArrowPressed ? "active" : ""
            }`}
          >
            &#9654;
          </div>
        )}
      </div>
    </div>
  );
};

export default App;
