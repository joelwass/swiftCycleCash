/**
 * Created by joelwasserman on 9/9/16.
 */

import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(
<CommentBox url="/api/comments" pollInterval={2000} />,
    document.getElementById('content')
);