const { app, BrowserWindow, dialog, ipcRenderer, ipcMain } = require('electron');
const path = require('path');

let mainWindow;

app.on('ready', () => {
  mainWindow = new BrowserWindow({
    title: 'Huella Funcionario',

    width: 475,
    height: 812,
    autoHideMenuBar: true,
    webPreferences: {
      nodeIntegration: true,
      preload: path.join(__dirname, 'preload.js'),
    },
    icon: path.join(__dirname, 'assets', 'icon.ico'),
  });



  mainWindow.loadURL('https://huella.funcionario.ccvalledupar.org.co');



  mainWindow.addListener('offline', () => {
    ipcRenderer.send('offline');
  });

  mainWindow.addListener('online', () => {
    ipcRenderer.send('online');
  });

  app.setLoginItemSettings({
    openAtLogin: true,
  })

});

ipcMain.on("offline", (event, arg) => {
  dialog.showMessageBox({
    type: "error",
    message: "No tienes conexión a internet",
  });
});

ipcMain.on("online", (event, arg) => {
  dialog.showMessageBox({
    type: "info",
    message: "Conexión a internet establecida",
  });
});
