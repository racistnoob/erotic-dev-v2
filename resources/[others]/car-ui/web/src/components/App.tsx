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

interface CarData {
    model: string;
    image: string;
}

const App: React.FC = () => {
    const [carData, setCarData] = useState<CarData[]>([]);
    const [hoveredIndex, setHoveredIndex] = useState<number | null>(null);

    const handleMouseEnter = (index: number) => {
        setHoveredIndex(index);
    };

    const handleMouseLeave = () => {
        setHoveredIndex(null);
    };

    // Fetch car data from Lua on component mount
    useEffect(() => {
        fetchCarDataFromLua();
    }, []);

    // Function to fetch car data from Lua
    const fetchCarDataFromLua = async () => {
        try {
            const response = await fetchNui<CarData[]>("getCarData");
            setCarData(response);
        } catch (error) {
            console.error("Error fetching car data:", error);
        }
    };

    // Function to handle car selection
    const handleCarSelection = (carModel: string) => {
        // Trigger client event in Lua with the selected car model
        fetchNui("carspawner:spawnVehicle", { model: carModel });
    };

    return (
        <div className="overlay">
            <div className="VehicleMenu-wrapper">
                <div className="VehicleMenu-container">
                    {carData.map((car, index) => (
                        <button key={index} className="VehicleMenu-card" onClick={() => handleCarSelection(car.model)}>
                            <img
                                src={car.image}
                                alt={car.model}
                                className="VehicleMenu-card-img"
                                onMouseEnter={() => handleMouseEnter(index)}
                                onMouseLeave={handleMouseLeave}
                                style={{ filter: hoveredIndex === index ? 'brightness(1.0)' : 'brightness(0.5)' }}
                            />
                            <p
                                className="VehicleMenu-card-label"
                                onMouseEnter={() => handleMouseEnter(index)}
                                onMouseLeave={handleMouseLeave}
                            >
                                {car.model}
                            </p>
                        </button>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default App;
