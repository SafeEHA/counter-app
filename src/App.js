import { useState } from "react";

const styles = {
  body: {
    backgroundColor: "grey",
    height: "100vh",
    width: "100vw",
    display: "flex",
    alignItems: "center",
    justifyContent: "center"
  },
  card: {
    backgroundColor: "white",
    height: "500px",
    width: "300px",
    borderRadius: "10px",
    padding: "20px",
    boxShadow: "20px 22px 15px -3px rgba(0,0,0,0.1)",
  },
  screen: {
    background: "linear-gradient(0deg, rgba(34,193,195,1) 0%, rgba(253,187,45,1) 100%)",
    height: "300px",
    width: "300px",
    borderRadius: "10px",
    display: "flex",
    alignItems: "center",
    justifyContent: "center"
  },
  h1: {
    fontSize: "40px"
  },
  buttons:{
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    gap: "30px",
    padding: "20px"
  },
  button: {
    backgroundColor: "lightgrey",
    height: "70px",
    width: "100px",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    borderRadius: "10px"
  }
  
}


function App() {
  const [count, setCount] = useState(0);

  function increaseBy5() {
    if (count <= 0) {
      setCount(count + 5);
    } else {
      setCount (0)
    }
  }

  function resetCount() {
    setCount(0);
  }

  function decreaseBy5() {
    setCount(count - 5);
  }
  
    return (
    <>
      <div style={styles.body}>
        <div style={styles.card}>
        <div style={styles.screen}>
        <h1 style={styles.h1}>{count}</h1>
        </div>
        <div style={styles.buttons}>
          <div style={styles.button} onClick={increaseBy5}>
            <h1 style={styles.h1}>+5</h1>
            </div>
          <div onClick={resetCount}>
            <h1>Reset</h1>
          </div>
            <div style={styles.button} onClick={decreaseBy5}>
              <h1 style={styles.h1}>-5</h1></div>
        </div>
        </div>
      </div>
    </>
  );
}

export default App;
