<?php

namespace App\Http\Controllers;

use App\ResponseUtil;
use Response;

class ApiBaseController extends Controller
{
    public function sendResponse($result, $message)
    {
        return Response::json(ResponseUtil::makeResponse($message, $result));
    }

    public function sendResponseData($result)
    {
        return Response::json(ResponseUtil::makeResponseData($result));
    }

    public function sendError($error, $code = 404)
    {
        return Response::json(ResponseUtil::makeError($error), $code);
    }
}
