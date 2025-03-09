from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from agno.agent import Agent
from agno.models.groq import Groq
from dotenv import load_dotenv
import json
import os

load_dotenv()
app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/analyse-student-1/")
async def analyse_student_1(data: str):
    agent = Agent(
        model=Groq(
            id="llama-3.3-70b-versatile",
            api_key=os.getenv("GROQ_API_KEY"),
        ),
        description="""
    You are an AI *Student Assessment Expert* that evaluates and enhances a student's exam preparation by analyzing their cognitive abilities across three key areas:  
    - *Analytical Thinking* (Logical reasoning, problem-solving, critical thinking)  
    - *Reasoning Ability* (Deductive/Inductive reasoning, decision-making skills)  
    - *Memory & Retention* (Ability to recall facts, definitions, and concepts) 

    Your ratings will be within the range of 1-10 for each area, with 1 being the lowest and 10 being the highest. You need to provide a detailed analysis of the student's cognitive abilities and suggest areas of improvement based on their performance.

    scopeofimprovement should contain the particular topics to be studied more for the student to improve

    # *Example Input Format:*
    "{
questionText": "Name the National game of India?",
 "modelAnswer": "India does not have an official National Game",
    "studentAnswer": "Hockey",
},
{
 "questionText": "What is the largest lake in the world?",
    "modelAnswer": "Caspian Sea",
    "studentAnswer": "Lake Superior",
}"
    

    ### *Example Response Format:* 
    {
    "analytical": 6,
    "reasoning": 8,
    "memory": 2,
    "scopeOfImprovement": "Indian national sports, Prominent lakes in the world"
    }
    """,
        instructions=[
            "Stricty evaluate the student's cognitive abilities in the three key areas.",
            "Provide a detailed analysis of the student's cognitive abilities.",
            "Use the provided example response format.",
            "The response must be in JSON format.",
        ],
        markdown=False,
    )

    val = agent.run(f"{data}", markdown=False).content

    response = json.loads(val)

    return {
        "response": response,
    }


@app.get("/generate-question/")
async def generate_question(data: str):
    agent = Agent(
        model=Groq(
            id="gemma2-9b-it",
            api_key=os.getenv("GROQ_API_KEY"),
        ),
        description="""
    You are an AI *Question Generation Expert* that creates Short Answer Questions (SAQs) to evaluate and enhance a student's exam preparation. You will generate 5 SAQs in JSON format based on the provided topics. Each question should test the student's cognitive abilities across three key areas: Analytical Thinking, Reasoning Ability, and Memory & Retention.

  The input will be a comma-separated list of topics. The output should be a JSON object containing an array of questions. Each question should include:
  - questionText: The text of the question.
  - modelAnswer: The correct answer to the question.

  # *Example Input Format:*
  "Indian national sports, Prominent lakes in the world"

  ### *Example Response Format:*
  {
    "questions": [
    "Which sport is most popular in India?",
    "What is the second largest lake in the world?",
    "Name a prominent lake in Africa.",
    "Which lake is known for its crystal-clear water?",
    "Which lake is the deepest in the world?",
    ]
  }
    """,
        instructions=[
            "Generate 5 SAQs based on the provided topics.",
            "Ensure each question tests the student's cognitive abilities in analytical thinking, reasoning ability, and memory retention.",
            "Use the provided example response format.",
            "The response must be strictly in JSON format.",
            "Don't add ```json at the start and end of the response",
        ],
        markdown=False,
    )

    val = agent.run(f"{data}", markdown=False).content
    print(val)

    response = json.loads(val)

    return {
        "response": response,
    }


@app.get("/get-transcript/")
async def get_transcript(data: str):
    agent = Agent(
        model=Groq(
            id="llama3-70b-8192",
            api_key=os.getenv("GROQ_API_KEY"),
        ),
        description="""
    You are an AI *Subject Matter Expert* that generates insightful and detailed transcripts for educational videos. You need to provide a detailed transcript for the given video content.

    ### *Example Input Format:* 
    {
    "analytical": 6,
    "reasoning": 8,
    "memory": 2,
    "scopeOfImprovement": "The student needs to focus on improving their memory and retention abilities by using mnemonic techniques and spaced repetition."
    }

    ### *Example Response Format:*
    {
    "transcript": "A plaintext transcript of the video transcript containing the concepts mentioned in scope of Improvemnt to teach the student Like there is no national sport of India and so forth"
    }
    """,
        instructions=[
            "Generate a detailed transcript for the given video content.",
            "Include the spoken words and any relevant information based on the scope of improvement.",
            "Use the provided example input and response format.",
            "no extra information should be added in the transcript",
            "The response must be strictly only in JSON format.",
        ],
        markdown=False,
    )

    val = agent.run(f"'{data}'", markdown=False).content

    print(val)

    response = json.loads(val)

    print(response)

    return {
        "response": response,
    }


@app.get("/study-material/")
async def study_material(data: str):
    agent = Agent(
        model=Groq(
            id="gemma2-9b-it",
            api_key=os.getenv("GROQ_API_KEY"),
        ),
        description="""
    You are a *Subject matter Expert* that evaluates and enhances a students exam preparation by creating a detailed study materials in the topics they lack in for a particular subject
    Output should be around 2 pages content not more than that

    
    ### *Example Input:*
    {
        "subject": "Thermodynmics",
        "topics": "Laws of Thermodynamics, Principles of Thermodynamics, Heat Transfer",
    }

    ### *Example Response Format:* 
    a detailed study guide for the topics in Thermodynamics: Laws of Thermodynamics, Principles of Thermodynamics, and Heat Transfer. This guide will help you understand the key concepts, formulas, and applications for each topic.

    Laws of Thermodynamics
    Zeroeth Law of Thermodynamics
    Statement: If two systems are each in thermal equilibrium with a third system, they are in thermal equilibrium with each other.
    Key Concept: This law introduces the concept of temperature.
    Application: Used to define temperature scales and thermometers.
    First Law of Thermodynamics
    Statement: Energy cannot be created or destroyed, only transformed from one form to another.
    Key Concept: Conservation of energy.
    Formula: ΔU = Q - W
    ΔU: Change in internal energy
    Q: Heat added to the system
    W: Work done by the system
    Application: Used in analyzing energy transformations in various processes.
    Second Law of Thermodynamics
    Statement: The total entropy of an isolated system can never decrease over time.
    Key Concept: Entropy is a measure of disorder or randomness.
    Formula: ΔS_total ≥ 0
    ΔS_total: Change in total entropy
    Application: Used to determine the direction of spontaneous processes and the efficiency of heat engines.
    Third Law of Thermodynamics
    Statement: As temperature approaches absolute zero, the entropy of a system approaches a constant minimum.
    Key Concept: Absolute zero is the lowest limit of the thermodynamic temperature scale.
    Application: Used in cryogenics and low-temperature physics.
    Principles of Thermodynamics
    System and Surroundings
    System: The part of the universe we are studying.
    Surroundings: Everything outside the system.
    Boundary: The real or imaginary surface that separates the system from its surroundings.
    Types of Systems
    Open System: Can exchange both matter and energy with the surroundings.
    Closed System: Can exchange energy but not matter with the surroundings.
    Isolated System: Cannot exchange either matter or energy with the surroundings.
    State Variables
    Intensive Properties: Do not depend on the amount of substance (e.g., temperature, pressure).
    Extensive Properties: Depend on the amount of substance (e.g., volume, mass).
    Processes
    Isothermal Process: Occurs at constant temperature.
    Adiabatic Process: Occurs without heat exchange with the surroundings.
    Isobaric Process: Occurs at constant pressure.
    Isochoric Process: Occurs at constant volume.
    Heat Transfer
    Modes of Heat Transfer
    Conduction: Heat transfer through direct contact.
    Formula: Q = kA(ΔT/L)
    Q: Heat transfer rate
    k: Thermal conductivity
    A: Cross-sectional area
    ΔT: Temperature difference
    L: Length of the material
    Convection: Heat transfer through the movement of fluids.
    Formula: Q = hA(ΔT)
    h: Convection heat transfer coefficient
    A: Surface area
    ΔT: Temperature difference
    Radiation: Heat transfer through electromagnetic waves.
    Formula: Q = εσA(T^4 - T_surroundings^4)
    ε: Emissivity
    σ: Stefan-Boltzmann constant
    A: Surface area
    T: Temperature of the object
    T_surroundings: Temperature of the surroundings
    Heat Exchangers
    Types: Parallel flow, counter flow, cross flow.
    Effectiveness: Ratio of actual heat transfer to the maximum possible heat transfer.
    Formula: ε = Q_actual / Q_max
    Fourier's Law of Heat Conduction
    Statement: The rate of heat transfer through a material is proportional to the negative gradient in the temperature and the area at right angles to that gradient.
    Formula: Q = -kA(dT/dx)
    Q: Heat transfer rate
    k: Thermal conductivity
    A: Cross-sectional area
    dT/dx: Temperature gradient
    """,
        instructions=[
            "Carefully curate a detailed study material focusing on the topics the student lacks in for a particular subject.",
            "Provide explanations, examples, and practice problems to enhance the student's understanding of the topics.",
            "Include key concepts, principles, and real-world applications to deepen the student's knowledge.",
            "Strictly should be in markdown format.",
            "Use LaTeX for mathematical equations.",
        ],
        markdown=True,
    )

    val = agent.run(f"{data}", markdown=True).content
    print(type(val))

    return {
        "response": f"{val}",
    }


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=10000)
