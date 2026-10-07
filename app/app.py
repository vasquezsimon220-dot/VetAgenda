from flask import Flask

app = Flask(__name__)


@app.route("/")
def home():
    return """
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>VetAgenda</title>

        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
                font-family: Arial, sans-serif;
            }

            body {
                background: #f4f7fb;
                color: #263238;
            }

            header {
                background: #2f80ed;
                color: white;
                padding: 25px;
                text-align: center;
            }

            header h1 {
                margin-bottom: 8px;
            }

            .container {
                max-width: 900px;
                margin: 35px auto;
                padding: 0 20px;
            }

            .welcome {
                background: white;
                padding: 25px;
                border-radius: 15px;
                margin-bottom: 25px;
                box-shadow: 0 3px 12px rgba(0,0,0,0.08);
            }

            .welcome h2 {
                margin-bottom: 10px;
            }

            .cards {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 15px;
                margin-bottom: 25px;
            }

            .card {
                background: white;
                padding: 20px;
                border-radius: 15px;
                text-align: center;
                box-shadow: 0 3px 12px rgba(0,0,0,0.08);
            }

            .card .icon {
                font-size: 30px;
                margin-bottom: 10px;
            }

            .appointments {
                background: white;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 3px 12px rgba(0,0,0,0.08);
            }

            .appointment {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px;
                margin-top: 12px;
                background: #f4f7fb;
                border-radius: 10px;
            }

            .status {
                background: #dff5e5;
                color: #218838;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: bold;
            }

            footer {
                text-align: center;
                margin-top: 30px;
                padding: 20px;
                color: #78909c;
            }

            @media (max-width: 650px) {
                .cards {
                    grid-template-columns: 1fr;
                }

                .appointment {
                    flex-direction: column;
                    gap: 10px;
                    align-items: flex-start;
                }
            }
        </style>
    </head>

    <body>

        <header>
            <h1>🐾 VetAgenda</h1>
            <p>Gestión de horas veterinarias</p>
        </header>

        <div class="container">

            <div class="welcome">
                <h2>¡Bienvenido a VetAgenda!</h2>
                <p>
                    Administra fácilmente las horas veterinarias
                    de tus mascotas.
                </p>
            </div>

            <div class="cards">

                <div class="card">
                    <div class="icon">🐶</div>
                    <h3>2</h3>
                    <p>Mascotas</p>
                </div>

                <div class="card">
                    <div class="icon">📅</div>
                    <h3>2</h3>
                    <p>Horas agendadas</p>
                </div>

                <div class="card">
                    <div class="icon">✅</div>
                    <h3>1</h3>
                    <p>Confirmada</p>
                </div>

            </div>

            <div class="appointments">

                <h2>📅 Próximas horas</h2>

                <div class="appointment">
                    <div>
                        <strong>🐶 Max</strong>
                        <p>Dra. Carolina · 08 Oct, 10:30</p>
                    </div>

                    <span class="status">Confirmada</span>
                </div>

                <div class="appointment">
                    <div>
                        <strong>🐱 Luna</strong>
                        <p>Dr. Felipe · 09 Oct, 15:00</p>
                    </div>

                    <span class="status">Pendiente</span>
                </div>

            </div>

        </div>

        <footer>
            VetAgenda © 2026 · Sistema de gestión veterinaria
        </footer>

    </body>
    </html>
    """


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
