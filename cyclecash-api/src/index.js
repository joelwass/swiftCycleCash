/**
 * Created by joelwasserman on 9/9/16.
 */

var React = require('react');
var ReactDOM = require('react-dom');
var App = require('./App');

ReactDOM.render(
<CommentBox url="/api/comments" pollInterval={2000} />,
    document.getElementById('content')
);