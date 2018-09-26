import React from 'react'
import { render } from 'react-dom'
import App from './containers/App'
import './index.css'
import { unregister } from './registerServiceWorker'

render(
  <App />,
  document.getElementById('root')
)
unregister()
