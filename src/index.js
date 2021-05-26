const express = require('express')
const app = express()
const exphbs = require('express-handlebars');
const path = require('path');
const routes = require('./routes/index.routes');

//settings
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.engine('.hbs', exphbs({ 
    defaultLayout:'main',
    layoutsDir: path.join(app.get('views'), 'layouts'),
    partialsDir: path.join(app.get('views'), 'partials'),
    extname:'.hbs'
}));

app.set('view engine', '.hbs');


//middlewares
app.use(express.urlencoded({ extended: false }))

//routes
app.use(routes)

//static files
app.use(express.static(path.join(__dirname, 'public')));


//listing server
app.listen(app.get('port'), () => {
  console.log('servidor activo')
})
