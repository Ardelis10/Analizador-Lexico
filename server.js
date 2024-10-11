const express = require('express');
const { spawn } = require('child_process');
const path = require('path');
const app = express();
const port = 3000;

// Middleware para procesar JSON y datos de formularios
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Configura express para servir archivos estáticos desde la carpeta "public"
app.use(express.static(path.join(__dirname, 'public')));

// Ruta para servir el archivo HTML (index.html) al acceder a la raíz
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Ruta para procesar el análisis léxico
app.post('/analizar', (req, res) => {
    const inputText = req.body.text;  // Aquí estamos extrayendo el texto enviado desde el cliente

    if (!inputText) {
        return res.status(400).json({ error: 'No se proporcionó texto para analizar' });
    }

    // Ejecutar el analizador léxico
    const lexerPath = path.join(__dirname, 'prueba.exe');
    const lexer = spawn(lexerPath);

    // Enviar el texto a la entrada estándar del analizador
    lexer.stdin.write(inputText);
    lexer.stdin.end(); // Cierra la entrada para indicar que se ha terminado de enviar datos

    let output = '';

    // Capturar la salida del analizador
    lexer.stdout.on('data', (data) => {
        output += data.toString();
    });

    // Manejar el evento de cierre del proceso
    lexer.on('close', (code) => {
        if (code !== 0) {
            console.error(`El analizador se cerró con el código ${code}`);
            return res.status(500).json({ error: 'Error al ejecutar el analizador léxico' });
        }
        // Enviar el resultado al cliente
        res.json({ message: 'Análisis completado', output });
    });
});

// Iniciar el servidor
app.listen(port, () => {
    console.log(`Servidor escuchando en http://localhost:${port}`);
});
