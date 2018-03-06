precision highp float;
//varying mediump vec2 vTexCoord;
//uniform mediump float kzTime;
//uniform mediump float OpenGLTimer;
//uniform mediump float PowerMeterTarget;

vec2 vTexCoord = vec2(0.0);
float kzTime = 0.0;
float OpenGLTimer;
float PowerMeterTarget = 1020.0;
float ScreenLoadingType = 0.0;



float MAX_POWER = 3800.0;
float MIN_POWER = 340.0;
float INNER_CIRCLE_RADIUS = 175.0;
float INNER_CIRCLE_OPACITY = 1.0;
bool needShowInnerCircle = true;
bool needShowBorder = false;

//vec2 u_resolution = vec2(680, 680);
float MIN_RESOLUTION_EDGE = min(u_resolution.x, u_resolution.y);
vec4 BACKGROUND_COLOR = vec4(0.0, 0.0, 0.0, 0.0);//////
const float NUMBER_OF_INNER_CIRCLE = 11.0; //10.0//

float SMALLEST_INNER_CIRCLE_BORDER_WIDTH = 4.0/MIN_RESOLUTION_EDGE;//4.0; //
vec4 SMALLEST_INNER_CIRCLE_BORDER_COLOR = vec4(0.6470588235294118, 0.6470588235294118, 0.6470588235294118, 1.0);
float INNER_CIRCLE_BORDER_WIDTH = 2.0/MIN_RESOLUTION_EDGE;//2.0;
float INNER_CIRCLE_DISTANCE = 6.0/MIN_RESOLUTION_EDGE;//6.0;

float BLANK_LOWER_LAUNCH_CONTROL_WIDTH = 4.0/MIN_RESOLUTION_EDGE;
vec4 LAUNCH_CONTROL_CIRCLE_COLOR = vec4(0.1803921568627451, 0.1803921568627451, 0.1803921568627451, 1.0);
float LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH = 5.0/MIN_RESOLUTION_EDGE;//5.0;
float LAUNCH_CONTROL_CIRCLE_RADIUS = 340.0/MIN_RESOLUTION_EDGE;//340.0;

vec4 POWER_CIRCLE_GRADIENT_COLOR = vec4(0.0, 0.6901960784313725, 0.9568627450980393, 1.0);
float POWER_CIRCLE_GRADIENT_BORER_WIDTH = 2.0 / MIN_RESOLUTION_EDGE;


vec4 POWER_BASE_CIRCLE_COLOR = vec4(0.10196078431372549, 0.10196078431372549, 0.10196078431372549, 1.0);
float POWER_BASE_CIRCLE_WIDTH = 16.0/MIN_RESOLUTION_EDGE;//18.0;
float POWER_CIRCLE_BORDER_WIDTH = 2.0/MIN_RESOLUTION_EDGE;//2.0;
float POWER_CIRCLE_RADIUS = 330.0/MIN_RESOLUTION_EDGE;//330.0;
vec4 POWER_CIRCLE_BORDER_COLOR = vec4(0.0, 0.6, 1.0, 1.0);

vec4 INNER_CIRCLE_NORMAL_GRADIENT_BEGIN = vec4(0.10196078431372549, 0.10196078431372549, 0.10196078431372549, 1.0);
vec4 INNER_CIRCLE_NORMAL_GRADIENT_END = vec4(0.2823529411764706, 0.2823529411764706, 0.2823529411764706, 1.0);

vec4 POINT_CIRCLE_COLOR = vec4(0.6, 0.6, 0.6, 1.0);

vec4 INNER_CIRCLE_CHARGED_GRADIENT_BEGIN = vec4(0.07450980392156863, 0.8196078431372549, 0.27058823529411763, 1.0);
vec4 INNER_CIRCLE_CHARGED_GRADIENT_END = vec4(0.09803921568627451, 0.5215686274509804, 0.10980392156862745, 1.0);

float RANGE_LINE_BORDER_WIDTH = 26.0 / MIN_RESOLUTION_EDGE;

float POWER_RANGE_TO_NAVIGATE = 1020.0;
float POWER_MAX_RANGE1 = 3400.0;
float POWER_MAX_RANGE2 = 3800.0;

float POWER_INDICATOR_WHITE_WIDTH = 5.0 / MIN_RESOLUTION_EDGE;
float POWER_INDICATOR_BLACK_WIDTH = 2.0 / MIN_RESOLUTION_EDGE;

float BLANK_WIDTH_IN_LAUNCH_CONTROL_CIRCLE = 4.0 / MIN_RESOLUTION_EDGE;

////
bool isBackgroundColor(vec4 inputColor) {
    vec4 v = BACKGROUND_COLOR;
    float dt = distance(inputColor.xyz, v.xyz);
    if (dt <= 0.0) {
        return true;
    }
    return false;
}

//
vec4 getGradientColor(vec4 fromColor, vec4 toColor, float percent) {
    float realPercent = min(percent, 1.0);
    if (realPercent < 0.0) {
        realPercent = 0.0;
    }
    return vec4(fromColor.xyz + (toColor.xyz - fromColor.xyz)*realPercent, 1.0);
}



vec4 drawSmothCircle(float borderWidth, vec4 borderColor, float radius, vec2 centerPoint) {
    vec2 currentPoint = vTexCoord.xy;
    float r = length(currentPoint - centerPoint);
    vec4 retVal = BACKGROUND_COLOR;
    if ((r >= (radius - borderWidth)) && (r <=  radius)) {
        retVal = borderColor;
    }
    else {
        float SmoothSideEdge = 0.0007352941176470588 * 2.0;
        if ((r > radius) && (r < (radius + SmoothSideEdge))) {
            float alpha = 1.0 - (r - radius) / SmoothSideEdge;
            retVal = getGradientColor(BACKGROUND_COLOR, borderColor, alpha);
        }

        if ((r < (radius- borderWidth)) && (r > (radius - SmoothSideEdge - borderWidth))) {
            float alpha = 1.0 - (radius - borderWidth - r) / SmoothSideEdge;
            retVal = getGradientColor(BACKGROUND_COLOR, borderColor, alpha);
        }


    }


    return retVal;
}

vec4 drawSmothCircle2(float borderWidth, float radius, vec2 centerPoint, int colorType) {

    vec2 currentPoint = vTexCoord;
    float r = length(currentPoint - centerPoint);
    vec4 retVal = BACKGROUND_COLOR;
    if ((r >= (radius - borderWidth)) && (r <=  (radius + borderWidth))) {
        vec3 finalColor = vec3(0.0);
        for( float i=1.; i < 10.0; ++i )
        {
            float t = abs(1.0 / ((r - radius)/r/4.0 * (i*1000.0)));
            finalColor +=  t * vec3( i * 0.075 +0.1, 0.5, 2.0 );
        }
        retVal = vec4(finalColor, 1.0);

    }
    return retVal;
}

vec4 drawSmothCircleWithSmoothColor(float borderWidth, vec4 borderColor, float radius, vec2 centerPoint, vec4 smoothColor) {
    vec2 currentPoint = vTexCoord.xy;
    float r = length(currentPoint - centerPoint);
    vec4 retVal = BACKGROUND_COLOR;
    if ((r >= (radius - borderWidth)) && (r <=  radius)) {
        retVal = borderColor;
    }
    else {

        float SmoothSideEdge = 1.0 / MIN_RESOLUTION_EDGE;
        if ((r > radius) && (r < (radius + SmoothSideEdge))) {
            float alpha = 1.0 - (r - radius) / SmoothSideEdge;
            retVal = getGradientColor(smoothColor, borderColor, alpha);
        }

        if ((r < (radius- borderWidth)) && (r > (radius - SmoothSideEdge - borderWidth))) {
            float alpha = 1.0 - (radius - borderWidth - r) / SmoothSideEdge;
            retVal = getGradientColor(smoothColor, borderColor, alpha);
        }
    }
    return retVal;
}

//
float getAngleFromPoint(vec2 inputPoint) {
    float ox = 0.5;
    float oy = 0.5;
    float x = inputPoint.x;
    float y = inputPoint.y;

    float huyen = sqrt((ox - x) * (ox - x) + (oy - y) * (oy - y));
    float ke = ox - x;
    float retVal = 0.0;

    float temp = degrees(acos(ke / huyen));
    if (y > oy) {
        retVal = temp;
    } else {
        retVal = 360.0 - temp;
    }


    return retVal;
}

//
vec4 drawLineForCircle(float angle, float circleRadius, float circelBorderWidth, vec2 centerPoint, float lineWidth, vec4 lineColor, bool isNeedBlackLine) {
    vec2 currentPoint = vTexCoord.xy;
    float angleOfCurrentPoint = getAngleFromPoint(currentPoint);
    float distanceToCenter = length(currentPoint - centerPoint);
    vec4 retVal = BACKGROUND_COLOR;

    if ((distanceToCenter >= (circleRadius - circelBorderWidth)) && (distanceToCenter <=  circleRadius)) {
        if (lineWidth < 0.0) {
            if (angleOfCurrentPoint <= angle) {
                float deltaAngle = angle - angleOfCurrentPoint;
                if (deltaAngle < 30.0) {
                    float distanceToLine = sin(radians(deltaAngle)) * distanceToCenter;
                    if (distanceToLine <= abs(lineWidth)) {
                        retVal = lineColor;
                    }

                    if (isNeedBlackLine) {
                        if ((distanceToLine > abs(lineWidth)) && (distanceToLine <= (abs(lineWidth) + POWER_INDICATOR_BLACK_WIDTH))) {
                            retVal = vec4(0.01, 0.0, 0.0, 1.0);
                        }
                    }
                }
            }
        } else {
            if (angleOfCurrentPoint >= angle) {
                float deltaAngle = angleOfCurrentPoint - angle;
                if (deltaAngle < 30.0) {
                    float distanceToLine = sin(radians(deltaAngle)) * distanceToCenter;
                    if (distanceToLine <= abs(lineWidth)) {
                        retVal = lineColor;
                    }

                    if (isNeedBlackLine) {
                        if ((distanceToLine > abs(lineWidth)) && (distanceToLine <= (abs(lineWidth) + POWER_INDICATOR_BLACK_WIDTH))) {
                            retVal = vec4(0.01, 0.0, 0.0, 1.0);
                        }
                    }
                }
            }
        }
    }
    return retVal;
}


float variation(vec2 v1, vec2 v2, float strength, float speed) {
    return sin(
        dot(v1, v2) * strength + kzTime * speed
    ) / 200.0;
}

vec3 paintCircle (vec2 uv, vec2 center, float rad, float width) {

    vec2 diff = center-uv;
    float len = length(diff);

    len += variation(diff, vec2(0.0, 1.0), 30.0, 10.0);
    len -= variation(diff, vec2(1.0, 0.0), 30.0, 10.0);

    float circle = smoothstep(rad-width, rad, len) - smoothstep(rad, rad+width, len);
    return vec3(circle);
}


vec4 drawWave(float radius, float alpha) {
    float SMALLEST_INNER_CIRCLE_RADIUS = INNER_CIRCLE_RADIUS/MIN_RESOLUTION_EDGE; //175.0
    vec4 retVal = BACKGROUND_COLOR;
    vec2 currentPoint = vTexCoord.xy;
    vec2 centerPoint = vec2(0.5);
    float distanceToCenter = length(currentPoint - centerPoint);
    vec4 waveColor0 = vec4(0.0, 0.6862745098039216, 0.9529411764705882, 1.0);
    vec4 waveColor1 = vec4(0.03137254901960784, 0.22745098039215686, 0.7450980392156863, 1.0);

    if (distanceToCenter <= SMALLEST_INNER_CIRCLE_RADIUS) {
        return BACKGROUND_COLOR;
    }
    float borderWidth = 0.0294117647058824;//0.0058823529411765;

    float angleOfCurrentPoint = getAngleFromPoint(currentPoint);

    float angle0 = 0.0;
    float angle1 = 20.0;
    float deltaDistance0 = 20.0;
    float deltaDistance1 = 0.0;
    deltaDistance0 = INNER_CIRCLE_DISTANCE*4.0;
    deltaDistance1 = INNER_CIRCLE_DISTANCE*2.0;
    if ((angleOfCurrentPoint >=angle0) && (angleOfCurrentPoint <= angle1)) {
        vec4 boderColor = waveColor0;
        float deltaDistance = deltaDistance0 + (angleOfCurrentPoint - angle0) * (deltaDistance1 - deltaDistance0) / (angle1 - angle0);
        retVal = drawSmothCircle2(borderWidth, radius + deltaDistance, centerPoint, 1);

    }

    angle0 = angle1;
    angle1 = 35.0;
    deltaDistance0 = deltaDistance1;
    deltaDistance1 = INNER_CIRCLE_DISTANCE*4.0;;
    if ((angleOfCurrentPoint >=angle0) && (angleOfCurrentPoint <= angle1)) {
        vec4 boderColor = waveColor0;
        float deltaDistance = deltaDistance0 + (angleOfCurrentPoint - angle0) * (deltaDistance1 - deltaDistance0) / (angle1 - angle0);
        retVal = drawSmothCircle2(borderWidth, radius + deltaDistance, centerPoint, 1);

    }

    angle0 = angle1;
    angle1 = 145.0;
    deltaDistance0 = deltaDistance1;
    deltaDistance1 = INNER_CIRCLE_DISTANCE*4.0;
    if ((angleOfCurrentPoint >=angle0) && (angleOfCurrentPoint <= angle1)) {
        vec4 boderColor = waveColor0;
        retVal = drawSmothCircle2(borderWidth, radius + deltaDistance1, centerPoint, 1);
    }

    angle0 = angle1;
    angle1 = 170.0;
    deltaDistance0 = deltaDistance1;
    deltaDistance1 = INNER_CIRCLE_DISTANCE*5.0;
    if ((angleOfCurrentPoint >=angle0) && (angleOfCurrentPoint <= angle1)) {
        vec4 boderColor = waveColor0;
        float deltaDistance = deltaDistance0 + (angleOfCurrentPoint - angle0) * (deltaDistance1 - deltaDistance0) / (angle1 - angle0);
        retVal = drawSmothCircle2(borderWidth, radius + deltaDistance, centerPoint, 1);

    }

    angle0 = angle1;
    angle1 = 180.0;
    deltaDistance0 = deltaDistance1;
    deltaDistance1 = INNER_CIRCLE_DISTANCE*4.0;
    if ((angleOfCurrentPoint >=angle0) && (angleOfCurrentPoint <= angle1)) {
        vec4 boderColor = waveColor0;
        float deltaDistance = deltaDistance0 + (angleOfCurrentPoint - angle0) * (deltaDistance1 - deltaDistance0) / (angle1 - angle0);
        retVal = drawSmothCircle2(borderWidth, radius + deltaDistance, centerPoint, 1);

    }

    angle0 = angle1;
    angle1 = 180.0 + 15.0;
    deltaDistance0 = deltaDistance1;
    deltaDistance1 = INNER_CIRCLE_DISTANCE*4.0;
    if ((angleOfCurrentPoint >=angle0) && (angleOfCurrentPoint <= angle1)) {
        vec4 boderColor = waveColor1;
        float deltaDistance = deltaDistance0 + (angleOfCurrentPoint - angle0) * (deltaDistance1 - deltaDistance0) / (angle1 - angle0);
        retVal = drawSmothCircle2(borderWidth, radius + deltaDistance, centerPoint, 1);

    }

    angle0 = angle1;
    angle1 = 250.0;
    deltaDistance0 = deltaDistance1;
    deltaDistance1 = INNER_CIRCLE_DISTANCE*2.0;
    if ((angleOfCurrentPoint >=angle0) && (angleOfCurrentPoint <= angle1)) {
        vec4 boderColor = waveColor1;
        float deltaDistance = deltaDistance0 + (angleOfCurrentPoint - angle0) * (deltaDistance1 - deltaDistance0) / (angle1 - angle0);
        retVal = drawSmothCircle2(borderWidth, radius + deltaDistance, centerPoint, 1);

    }

    angle0 = angle1;
    angle1 = 300.0;
    deltaDistance0 = deltaDistance1;
    deltaDistance1 = INNER_CIRCLE_DISTANCE*6.0;
    if ((angleOfCurrentPoint >=angle0) && (angleOfCurrentPoint <= angle1)) {
        vec4 boderColor = waveColor1;
        float deltaDistance = deltaDistance0 + (angleOfCurrentPoint - angle0) * (deltaDistance1 - deltaDistance0) / (angle1 - angle0);
        retVal = drawSmothCircle2(borderWidth, radius + deltaDistance, centerPoint, 1);

    }

    angle0 = angle1;
    angle1 = 360.0;
    deltaDistance0 = deltaDistance1;
    deltaDistance1 = INNER_CIRCLE_DISTANCE*4.0;
    if ((angleOfCurrentPoint >=angle0) && (angleOfCurrentPoint <= angle1)) {
        vec4 boderColor = waveColor0;
        float deltaDistance = deltaDistance0 + (angleOfCurrentPoint - angle0) * (deltaDistance1 - deltaDistance0) / (angle1 - angle0);
        retVal = drawSmothCircle2(borderWidth, radius + deltaDistance, centerPoint, 1);

    }

    return  vec4 (vec4(retVal*alpha).xyz, 1.0);
}





vec4 drawWave2(float radius, float alpha) {
    float SMALLEST_INNER_CIRCLE_RADIUS = INNER_CIRCLE_RADIUS/MIN_RESOLUTION_EDGE; //175.0
    vec4 retVal = BACKGROUND_COLOR;
    vec2 currentPoint = vTexCoord;
    vec2 centerPoint = vec2(0.5);
    float distanceToCenter = length(currentPoint - centerPoint);
    vec4 waveColor0 = vec4(0.0, 0.6862745098039216, 0.9529411764705882, 1.0);
    vec4 waveColor1 = vec4(0.03137254901960784, 0.22745098039215686, 0.7450980392156863, 1.0);
    if (distanceToCenter <= SMALLEST_INNER_CIRCLE_RADIUS) {
        return BACKGROUND_COLOR;
    }
    float borderWidth = 0.0058823529411765;

    float angleOfCurrentPoint = getAngleFromPoint(currentPoint);

    float angle0 = 0.0;
    float angle1 = 20.0;
    float deltaDistance0 = 20.0;
    float deltaDistance1 = 0.0;


    angle0 = 35.0;
    angle1 = 145.0;
    deltaDistance0 = INNER_CIRCLE_DISTANCE*4.0;
    deltaDistance1 = INNER_CIRCLE_DISTANCE*4.0;
    if ((angleOfCurrentPoint >=angle0) && (angleOfCurrentPoint <= angle1)) {
        vec4 boderColor = waveColor0;
        float color = smoothstep(0.0029411764705882, borderWidth * 3.0 , abs(distanceToCenter - (radius+deltaDistance1)));
        float temp = 1.0 - color;
        retVal = BACKGROUND_COLOR;
        if (temp > 0.0) {
            retVal = boderColor;
        }
    }



    angle0 = 300.0;
    angle1 = 360.0;
    deltaDistance0 = INNER_CIRCLE_DISTANCE*6.0;
    deltaDistance1 = INNER_CIRCLE_DISTANCE*4.0;
    if ((angleOfCurrentPoint >=angle0) && (angleOfCurrentPoint <= angle1)) {
        vec4 boderColor = waveColor0;
        float deltaDistance = deltaDistance0 + (angleOfCurrentPoint - angle0) * (deltaDistance1 - deltaDistance0) / (angle1 - angle0);

        float color = smoothstep(0.0029411764705882, borderWidth * 3.0 , abs(distanceToCenter - (radius + deltaDistance)));
        float temp = 1.0 - color;
        retVal = BACKGROUND_COLOR;
        if (temp > 0.0) {
            retVal = boderColor;
        }

    }

    return  vec4(vec4(retVal*(min(0.0, alpha - 0.2))).xyz, 1.0);
}


float convertPowerToAngle(float currentPowerMeterValue, float maxAngleRange) {
    float PieRate = 0.0;
    float currentPowerInAngle = 0.0;
    if (currentPowerMeterValue >= POWER_RANGE_TO_NAVIGATE) {
        if (MAX_POWER < POWER_MAX_RANGE2) {
            PieRate = (currentPowerMeterValue - POWER_RANGE_TO_NAVIGATE) / (POWER_MAX_RANGE1 - POWER_RANGE_TO_NAVIGATE);
            if (PieRate > 0.0) {
                currentPowerInAngle = PieRate * maxAngleRange;
            }
        } else {
            if (currentPowerMeterValue <= POWER_MAX_RANGE1) {
                PieRate = (currentPowerMeterValue - POWER_RANGE_TO_NAVIGATE) / (POWER_MAX_RANGE1 - POWER_RANGE_TO_NAVIGATE);
                if (PieRate > 0.0) {
                    currentPowerInAngle = PieRate * 180.0;
                }
            } else {
                PieRate =  (currentPowerMeterValue - POWER_MAX_RANGE1) / (POWER_MAX_RANGE2 - POWER_MAX_RANGE1);
                if (PieRate > 0.0) {
                    currentPowerInAngle = 180.0 + (maxAngleRange - 180.0)* PieRate ;
                }
            }
        }

    } else {
        float tempRange = POWER_RANGE_TO_NAVIGATE - 340.0;
        float tempRate = (358.5 - 317.0)/tempRange;
        float tempDelta = POWER_RANGE_TO_NAVIGATE - currentPowerMeterValue;
        //
        if (tempDelta > 0.0) {
            PieRate =  tempDelta / tempRange;
            currentPowerInAngle = 358.5 - tempRate * tempDelta;
        }
    }
    return currentPowerInAngle;
}


void main() {

    ScreenLoadingType = 1.0;
    vTexCoord = gl_FragCoord.xy / u_resolution.xy;
    kzTime = u_time;
    //OpenGLTimer;
    PowerMeterTarget = 0.0;
    vec4 retColor = BACKGROUND_COLOR;
    float x = vTexCoord.x;
    float y = vTexCoord.y;
    float ox = 0.5;
    float oy = 0.5;
    vec2 currentPoint = vTexCoord.xy;
    vec2 centerPoint = vec2(0.5);
    vec4 tempColor = BACKGROUND_COLOR;
    float distanceToCenter = length(currentPoint - centerPoint);
    float SMALLEST_INNER_CIRCLE_RADIUS = INNER_CIRCLE_RADIUS/MIN_RESOLUTION_EDGE; //175.0


    float maxAngleRange = (MAX_POWER > POWER_MAX_RANGE1) ? (225.0 - 1.6) : 180.0;
    float maxPowerRange =  (MAX_POWER > POWER_MAX_RANGE1) ? (POWER_MAX_RANGE2 - POWER_RANGE_TO_NAVIGATE) : (POWER_MAX_RANGE1 - POWER_RANGE_TO_NAVIGATE);
    float maxAngleToDisplay = convertPowerToAngle(MAX_POWER, maxAngleRange);
    float minAngleToDisplay = convertPowerToAngle(MIN_POWER, maxAngleRange);
    float angleOfCurrentPoint = getAngleFromPoint(vec2(x, y));
    float PieRate = 0.0;
    float currentPowerInAngle = 0.0;
    //kzTime = OpenGLTimer;
    float currentPowerMeterValue = min(PowerMeterTarget, MAX_POWER);
    if (currentPowerMeterValue < MIN_POWER) {
        currentPowerMeterValue = MIN_POWER;
    }
    currentPowerInAngle = convertPowerToAngle(currentPowerMeterValue, maxAngleRange);


    //Loading in normal mode
    if (ScreenLoadingType < 1.0) {

        float eLaunchRadius = maxAngleToDisplay;
        if (eLaunchRadius < 180.0) {
            eLaunchRadius = 180.0;
        }

        //Draw eLaunch border
        if ((angleOfCurrentPoint <= eLaunchRadius) && needShowBorder){
            vec4 tempColor = drawSmothCircle(LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, LAUNCH_CONTROL_CIRCLE_COLOR, LAUNCH_CONTROL_CIRCLE_RADIUS, centerPoint);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }
        }

        if (angleOfCurrentPoint <= (maxAngleToDisplay)) {
            tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, POWER_BASE_CIRCLE_COLOR, POWER_CIRCLE_RADIUS, centerPoint);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }

            if ((angleOfCurrentPoint <= currentPowerInAngle) && (currentPowerMeterValue >= POWER_RANGE_TO_NAVIGATE)) {
                tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, POWER_CIRCLE_BORDER_COLOR, POWER_CIRCLE_RADIUS, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }

                tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, POWER_CIRCLE_GRADIENT_COLOR, POWER_CIRCLE_RADIUS, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }


                if ((y > (oy + POWER_CIRCLE_GRADIENT_BORER_WIDTH)) || (x > ox)) {
                    tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH - POWER_CIRCLE_BORDER_WIDTH * 2.0, POWER_CIRCLE_GRADIENT_COLOR, POWER_CIRCLE_RADIUS - POWER_CIRCLE_BORDER_WIDTH, centerPoint);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }

                    vec4 gradientColor = getGradientColor(vec4(vec3(0.0), 1.0), POWER_CIRCLE_GRADIENT_COLOR, angleOfCurrentPoint/currentPowerInAngle);
                    tempColor = drawSmothCircleWithSmoothColor(POWER_BASE_CIRCLE_WIDTH - POWER_CIRCLE_BORDER_WIDTH * 2.0, gradientColor, POWER_CIRCLE_RADIUS - POWER_CIRCLE_BORDER_WIDTH, centerPoint, POWER_CIRCLE_GRADIENT_COLOR);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }
                }

            }

        }

        //Draw power indicator when power > charging
        if (currentPowerMeterValue > POWER_RANGE_TO_NAVIGATE){
            //drawLineForCircle
            tempColor = drawLineForCircle(currentPowerInAngle, POWER_CIRCLE_RADIUS, POWER_BASE_CIRCLE_WIDTH, centerPoint, -POWER_INDICATOR_WHITE_WIDTH, vec4(1.0), true);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }
        }

        if (needShowBorder) {
            if (y < (oy - POWER_INDICATOR_BLACK_WIDTH)) {
                if (((angleOfCurrentPoint > 180.0) && (angleOfCurrentPoint < 225.0)) ||
                    ((angleOfCurrentPoint > 240.0) && (angleOfCurrentPoint < 300.0)) ||
                    ((angleOfCurrentPoint > 315.0) && (angleOfCurrentPoint < 360.0))) {
                    vec4 tempColor = drawSmothCircle(LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, LAUNCH_CONTROL_CIRCLE_COLOR, LAUNCH_CONTROL_CIRCLE_RADIUS, centerPoint);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }
                }

                //drawLineForCircle
                tempColor = drawLineForCircle(315.0, LAUNCH_CONTROL_CIRCLE_RADIUS, RANGE_LINE_BORDER_WIDTH, centerPoint, LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, LAUNCH_CONTROL_CIRCLE_COLOR, false);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }

                //drawLineForCircle
                tempColor = drawLineForCircle(225.0, LAUNCH_CONTROL_CIRCLE_RADIUS, RANGE_LINE_BORDER_WIDTH, centerPoint, -LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, LAUNCH_CONTROL_CIRCLE_COLOR, false);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }
            }
        }


        if (((y <= (oy - POWER_INDICATOR_BLACK_WIDTH))|| (x > ox)) && (angleOfCurrentPoint >=minAngleToDisplay)) {
            tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, POWER_BASE_CIRCLE_COLOR, POWER_CIRCLE_RADIUS, centerPoint);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }
            if (currentPowerMeterValue < POWER_RANGE_TO_NAVIGATE) {
                if (angleOfCurrentPoint >= currentPowerInAngle) {
                    tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, POWER_CIRCLE_BORDER_COLOR, POWER_CIRCLE_RADIUS, centerPoint);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }

                    tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, INNER_CIRCLE_CHARGED_GRADIENT_BEGIN, POWER_CIRCLE_RADIUS, centerPoint);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }

                    tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH - POWER_CIRCLE_BORDER_WIDTH * 2.0, INNER_CIRCLE_CHARGED_GRADIENT_BEGIN, POWER_CIRCLE_RADIUS - POWER_CIRCLE_BORDER_WIDTH, centerPoint);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }

                    if (y <= (oy - POWER_INDICATOR_BLACK_WIDTH - POWER_CIRCLE_GRADIENT_BORER_WIDTH)) {
                        vec4 gradientColor = getGradientColor(INNER_CIRCLE_CHARGED_GRADIENT_BEGIN, INNER_CIRCLE_CHARGED_GRADIENT_END, 1.0 - (358.5 - angleOfCurrentPoint)/ 40.0);
                        tempColor = drawSmothCircleWithSmoothColor(POWER_BASE_CIRCLE_WIDTH - POWER_CIRCLE_BORDER_WIDTH * 2.0, gradientColor, POWER_CIRCLE_RADIUS - POWER_CIRCLE_BORDER_WIDTH, centerPoint, INNER_CIRCLE_CHARGED_GRADIENT_BEGIN);
                        if (!isBackgroundColor(tempColor)) {
                            retColor = tempColor;
                        }
                    }
                }
                //drawLineForCircle
                tempColor = drawLineForCircle(currentPowerInAngle, POWER_CIRCLE_RADIUS, POWER_BASE_CIRCLE_WIDTH, centerPoint, POWER_INDICATOR_WHITE_WIDTH, vec4(1.0), true);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }
            }
        }


        if (currentPowerMeterValue == POWER_RANGE_TO_NAVIGATE) {
            //drawLineForCircle
            tempColor = drawLineForCircle(360.0, POWER_CIRCLE_RADIUS, POWER_BASE_CIRCLE_WIDTH, centerPoint, -POWER_INDICATOR_BLACK_WIDTH, vec4(1.0), false);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }
        }

        if (needShowInnerCircle) {
            for (float i = 0.0; i < NUMBER_OF_INNER_CIRCLE; i += 1.0) {
                float subBorderWidth = SMALLEST_INNER_CIRCLE_BORDER_WIDTH;
                vec4 gradientColor = SMALLEST_INNER_CIRCLE_BORDER_COLOR;
                float subRadius = SMALLEST_INNER_CIRCLE_RADIUS + i*INNER_CIRCLE_DISTANCE;
                ////
                if (i > 0.0) {
                    subBorderWidth = INNER_CIRCLE_BORDER_WIDTH;
                    float pointPercent = 0.0;
                    if (currentPowerMeterValue > POWER_RANGE_TO_NAVIGATE) {
                        if (angleOfCurrentPoint >= currentPowerInAngle) {
                            tempColor = drawSmothCircle(subBorderWidth, INNER_CIRCLE_NORMAL_GRADIENT_BEGIN, subRadius, centerPoint);
                            tempColor = vec4(tempColor.xyz*INNER_CIRCLE_OPACITY, 1.0);
                            if (!isBackgroundColor(tempColor)) {
                                retColor = tempColor;
                            }
                        } else {
                            pointPercent = angleOfCurrentPoint / currentPowerInAngle;
                            gradientColor = getGradientColor(INNER_CIRCLE_NORMAL_GRADIENT_BEGIN, INNER_CIRCLE_NORMAL_GRADIENT_END, pointPercent);
                            tempColor = drawSmothCircle(subBorderWidth, gradientColor, subRadius, centerPoint);
                            tempColor = vec4(tempColor.xyz*INNER_CIRCLE_OPACITY, 1.0);
                            if (!isBackgroundColor(tempColor)) {
                                retColor = tempColor;
                            }
                        }
                    } else if (currentPowerMeterValue < POWER_RANGE_TO_NAVIGATE){
                        if ((angleOfCurrentPoint >= currentPowerInAngle) && (angleOfCurrentPoint <= 360.0)) {

                            pointPercent = (360.0 - angleOfCurrentPoint) / (360.0 - currentPowerInAngle);
                            gradientColor = getGradientColor(INNER_CIRCLE_NORMAL_GRADIENT_BEGIN, vec4(0.09803921568627451, 0.24705882352941178, 0.13725490196078433, 1.0), pointPercent);
                            tempColor = drawSmothCircle(subBorderWidth, gradientColor, subRadius, centerPoint);
                            tempColor = vec4(tempColor.xyz*INNER_CIRCLE_OPACITY, 1.0);
                            if (!isBackgroundColor(tempColor)) {
                                retColor = tempColor;
                            }

                        } else {
                            tempColor = drawSmothCircle(subBorderWidth, INNER_CIRCLE_NORMAL_GRADIENT_BEGIN, subRadius, centerPoint);
                            tempColor = vec4(tempColor.xyz*INNER_CIRCLE_OPACITY, 1.0);
                            if (!isBackgroundColor(tempColor)) {
                                retColor = tempColor;
                            }
                        }
                    } else {
                        tempColor = drawSmothCircle(subBorderWidth, vec4(0.10196078431372549, 0.10196078431372549, 0.10196078431372549, 1.0), subRadius, centerPoint);
                        tempColor = vec4(tempColor.xyz*INNER_CIRCLE_OPACITY, 1.0);
                        if (!isBackgroundColor(tempColor)) {
                            retColor = tempColor;
                        }
                    }

                    float smallCircleRadius = (subBorderWidth + 1.0) / 2.0;
                    float tempR = SMALLEST_INNER_CIRCLE_RADIUS + i*INNER_CIRCLE_DISTANCE - INNER_CIRCLE_BORDER_WIDTH/2.0;
                    float px = tempR * abs(cos(radians(currentPowerInAngle)));
                    float py = tempR * abs(sin(radians(currentPowerInAngle)));
                    if (currentPowerInAngle <= 90.0) {
                        px = ox - px;
                        py = oy + py;
                    } else if (currentPowerInAngle <= 180.0){
                        px = ox + px;
                        py = oy + py;
                    } else if (currentPowerInAngle <= 270.0){
                        px = ox + px;
                        py = oy - py;
                    } else {
                        px = ox - px;
                        py = oy - py;
                    }
                    tempColor = drawSmothCircle(smallCircleRadius, POINT_CIRCLE_COLOR, 0.0016, vec2(px, py));
                    tempColor = vec4(tempColor.xyz*INNER_CIRCLE_OPACITY, 1.0);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }

                } else {
                    if (needShowBorder) {
                        tempColor = drawSmothCircle(subBorderWidth, gradientColor, subRadius, centerPoint);
                        if (!isBackgroundColor(tempColor)) {
                            retColor = tempColor;
                        }
                    }
                }
            }


        }
    } else if (ScreenLoadingType < 2.0) {
        vec4 color0 = LAUNCH_CONTROL_CIRCLE_COLOR;
        vec4 color1 = POWER_BASE_CIRCLE_COLOR;
        float biggestCircleTime0 = 3.1;
        float biggestCircleTime1 = 3.437;
        float biggestCircleTime2 = 3.9;
        vec4 greenColorToChange0 = vec4(0.0, 0.6, 0.8392156862745098, 1.0);
        vec4 greenColorToChange1 = vec4(vec3(greenColorToChange0.xyz * 0.5), 1.0);

        float showBelowTime0 = 3.51;
        float showBelowTime1 = 3.9;

        if (kzTime >=  biggestCircleTime0) {
            if (kzTime < biggestCircleTime1) {
                float tempA = (kzTime - biggestCircleTime0)/(biggestCircleTime1 - biggestCircleTime0);
                color0 = getGradientColor(BACKGROUND_COLOR, greenColorToChange0, tempA);
                color1 = getGradientColor(BACKGROUND_COLOR, greenColorToChange1, tempA);

            } else if (kzTime < biggestCircleTime2){
                float tempA = (kzTime - biggestCircleTime1)/(biggestCircleTime2 - biggestCircleTime1);
                tempA = min(1.0, tempA);
                color0 = getGradientColor(greenColorToChange0, LAUNCH_CONTROL_CIRCLE_COLOR, tempA);
                color1 = getGradientColor(greenColorToChange1, POWER_BASE_CIRCLE_COLOR, tempA);
            } else {
                color0 = LAUNCH_CONTROL_CIRCLE_COLOR;
                color1 = POWER_BASE_CIRCLE_COLOR;
            }
        }

        if (y >= oy) {
            if (kzTime >=  biggestCircleTime0) {
                vec4 tempColor = drawSmothCircle(LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, color0, LAUNCH_CONTROL_CIRCLE_RADIUS, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }

                if (kzTime >= showBelowTime0){
                    tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, color1, POWER_CIRCLE_RADIUS, centerPoint);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }
                } else {
                    //drawLineForCircle
                    tempColor = drawLineForCircle(0.0, LAUNCH_CONTROL_CIRCLE_RADIUS, RANGE_LINE_BORDER_WIDTH, centerPoint, POWER_INDICATOR_WHITE_WIDTH, color0, false);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }

                    //drawLineForCircle
                    tempColor = drawLineForCircle(180.0, LAUNCH_CONTROL_CIRCLE_RADIUS, RANGE_LINE_BORDER_WIDTH, centerPoint, -POWER_INDICATOR_WHITE_WIDTH, color0, false);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }
                }
              }
        }


        float firstShowBelowY = oy - POWER_INDICATOR_WHITE_WIDTH;
        float showBelowRate = (0.0 -firstShowBelowY)/(showBelowTime1 - showBelowTime0);
        float currentShowBelowY = max(0.0, firstShowBelowY + showBelowRate * (kzTime - showBelowTime0));
        if (kzTime >= showBelowTime0) {
            if ((y < firstShowBelowY) && (y >= currentShowBelowY)) {
                float deltaShowBelow = kzTime - showBelowTime0;
                if (((angleOfCurrentPoint > 180.0) && (angleOfCurrentPoint < 225.0))
                        /*|| ((angleOfCurrentPoint > 240.0) && (angleOfCurrentPoint < 300.0))*/
                        ||((angleOfCurrentPoint > 315.0) && (angleOfCurrentPoint < 360.0))) {
                    vec4 tempColor = drawSmothCircle(LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, color0, LAUNCH_CONTROL_CIRCLE_RADIUS, centerPoint);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }
                }

                if (kzTime <= showBelowTime1) {
                    float tempDistanceY = currentShowBelowY - oy + POWER_INDICATOR_WHITE_WIDTH;
                    if ((angleOfCurrentPoint > 180.0) && (angleOfCurrentPoint < 225.0)) {
                        float edgeLength = sqrt(LAUNCH_CONTROL_CIRCLE_RADIUS * LAUNCH_CONTROL_CIRCLE_RADIUS - tempDistanceY*tempDistanceY);
                        float tempAngle = getAngleFromPoint(vec2(ox + edgeLength,currentShowBelowY));
                        //drawLineForCircle
                        tempColor = drawLineForCircle(tempAngle, LAUNCH_CONTROL_CIRCLE_RADIUS, RANGE_LINE_BORDER_WIDTH, centerPoint, LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, color0, false);
                        if (!isBackgroundColor(tempColor)) {
                            retColor = tempColor;
                        }
                    }

                    if ((angleOfCurrentPoint > 315.0) && (angleOfCurrentPoint < 360.0)) {
                        float edgeLength = sqrt(LAUNCH_CONTROL_CIRCLE_RADIUS * LAUNCH_CONTROL_CIRCLE_RADIUS - tempDistanceY*tempDistanceY);
                        float tempAngle = getAngleFromPoint(vec2(ox - edgeLength,currentShowBelowY));
                        //drawLineForCircle
                        tempColor = drawLineForCircle(tempAngle, LAUNCH_CONTROL_CIRCLE_RADIUS, RANGE_LINE_BORDER_WIDTH, centerPoint, -LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, color0, false);
                        if (!isBackgroundColor(tempColor)) {
                            retColor = tempColor;
                        }
                    }
                } else {
                    //drawLineForCircle
                    tempColor = drawLineForCircle(315.0, LAUNCH_CONTROL_CIRCLE_RADIUS, RANGE_LINE_BORDER_WIDTH, centerPoint, LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, color0, false);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }

                    //drawLineForCircle
                    tempColor = drawLineForCircle(225.0, LAUNCH_CONTROL_CIRCLE_RADIUS, RANGE_LINE_BORDER_WIDTH, centerPoint, -LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, color0, false);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }
                }
            }
        }

        if ((angleOfCurrentPoint > 240.0) && (angleOfCurrentPoint < 300.0)) {
            float timeArg0 = 3.4;
            float timeArg1 = 3.51;
            float timeArg3 = 3.9;
            if (kzTime >= timeArg0) {
                vec4 tempColor = drawSmothCircle(LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, color0, LAUNCH_CONTROL_CIRCLE_RADIUS, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }
            }
        }


        float changeValueTime0 = 3.9;
        float changeValueTime1 = 4.05;
           if (kzTime <= 3.9) {
            currentPowerInAngle = 180.0;
        } else if (kzTime <= 4.05) {
            currentPowerInAngle = 180.0 - (kzTime - changeValueTime0) * 180.0/(changeValueTime1 - changeValueTime0);
        } else {
            currentPowerInAngle = 0.0;
        }

        float waveTime0 = 2.5;
        float waveTime1 = 3.4;
        float startWaveR =  SMALLEST_INNER_CIRCLE_RADIUS / 4.0;
        float maxWaveR = SMALLEST_INNER_CIRCLE_RADIUS + 9.0*INNER_CIRCLE_DISTANCE;
        float waveR = 0.0;
        float waveA = 0.0;
        if ((kzTime >= waveTime0) && (kzTime <= waveTime1)) {
            waveR = startWaveR + (kzTime - waveTime0)*(maxWaveR - startWaveR)/(waveTime1 - waveTime0);
            waveA = 1.0 - (kzTime - waveTime0)/(waveTime1 - waveTime0);
        }


        if ((kzTime >= waveTime0) && (kzTime <= waveTime1)) {

            tempColor = drawWave2(waveR, 1.0);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }

        }


        float smallCircleTime0 = 3.0;
        float smallCircleTime1 = 3.529;
        float smallCircleTimeStamp = (smallCircleTime1 - smallCircleTime0) / 10.0;
        float currentIndexSmall = (kzTime - smallCircleTime0) / smallCircleTimeStamp;

        for (float i = 0.0; i < NUMBER_OF_INNER_CIRCLE; i += 1.0) {
            float subBorderWidth = SMALLEST_INNER_CIRCLE_BORDER_WIDTH;
            float subRadius = SMALLEST_INNER_CIRCLE_RADIUS + i*INNER_CIRCLE_DISTANCE;

            if (i > 0.0) {
                subBorderWidth = INNER_CIRCLE_BORDER_WIDTH;
                vec4 gradientColor = SMALLEST_INNER_CIRCLE_BORDER_COLOR;
                float pointPercent = 0.0;
                if (currentPowerMeterValue > POWER_RANGE_TO_NAVIGATE) {
                    if (angleOfCurrentPoint >= currentPowerInAngle) {
                        gradientColor = INNER_CIRCLE_NORMAL_GRADIENT_BEGIN;
                    } else {
                        pointPercent = angleOfCurrentPoint / currentPowerInAngle;
                        gradientColor = getGradientColor(INNER_CIRCLE_NORMAL_GRADIENT_BEGIN, INNER_CIRCLE_NORMAL_GRADIENT_END, pointPercent);

                    }
                    float changeGreenTime0 = 3.2;
                    float changeGreenTime1 = 3.7;
                    float changeGreenStamp = (changeGreenTime1 - changeGreenTime0)/10.0;
                    vec4 greenChangeColor = vec4(0.0, 0.6, 0.8392156862745098, 1.0);
                    float currentIndexGreen = (kzTime - changeGreenTime0) / changeGreenStamp;
                    vec4 tempGreenColor = gradientColor;
                    float tempVal = (changeGreenStamp * i);
                    float deltaKzTimeChangeGreen0 = kzTime - changeGreenTime0 - (i -1.0) * changeGreenStamp;
                    float deltaKzTimeChangeGreen1 = kzTime - changeGreenTime0;
                    if (deltaKzTimeChangeGreen0 <= tempVal) {
                        float tempA = deltaKzTimeChangeGreen0 / tempVal;
                        gradientColor = getGradientColor(BACKGROUND_COLOR, greenChangeColor, tempA);
                    } else {
                        float tempA = min((deltaKzTimeChangeGreen0 - tempVal) / (changeGreenStamp * 2.0), 1.0);
                        gradientColor = getGradientColor(greenChangeColor, tempGreenColor, tempA);
                    }
                    tempColor = drawSmothCircle(subBorderWidth, gradientColor, subRadius, centerPoint);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }

                } else if (currentPowerMeterValue < POWER_RANGE_TO_NAVIGATE){
                    //Do nothing
                } else {
                    tempColor = drawSmothCircle(subBorderWidth, vec4(0.10196078431372549, 0.10196078431372549, 0.10196078431372549, 1.0), subRadius, centerPoint);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }
                }


                // Draw white point
                if (currentIndexSmall >= i) {
                    float smallCircleRadius = (subBorderWidth + 1.0) / 2.0;
                    float tempR = SMALLEST_INNER_CIRCLE_RADIUS + i*INNER_CIRCLE_DISTANCE - INNER_CIRCLE_BORDER_WIDTH/2.0;
                    float px = tempR * abs(cos(radians(currentPowerInAngle)));
                    float py = tempR * abs(sin(radians(currentPowerInAngle)));
                    if (currentPowerInAngle <= 90.0) {
                        px = ox - px;
                        py = oy + py;
                    } else if (currentPowerInAngle <= 180.0){
                        px = ox + px;
                        py = oy + py;
                    } else if (currentPowerInAngle <= 270.0){
                        px = ox + px;
                        py = oy - py;
                    } else {
                        px = ox - px;
                        py = oy - py;
                    }
                    tempColor = drawSmothCircle(smallCircleRadius, POINT_CIRCLE_COLOR, 0.0016, vec2(px, py));
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }
                }
            } else {
                // Smallest circle
                vec4 gradientColor = SMALLEST_INNER_CIRCLE_BORDER_COLOR;
                float alphaForSmallestCircle = 0.0;
                float colorForSmallestCircle = 0.0;
                float smallestTime0 = 2.4;
                float smallestTime1 = 2.56;
                if (kzTime <= smallestTime0) {
                    alphaForSmallestCircle = 0.0;
                } else if ((kzTime > smallestTime0) && (kzTime <= smallestTime1)) {
                    alphaForSmallestCircle = 1.0 /(smallestTime1 - smallestTime0) * (kzTime - smallestTime0);
                } else {
                    alphaForSmallestCircle = 1.0;
                }



                tempColor = drawSmothCircle(subBorderWidth, vec4(gradientColor.xyz * alphaForSmallestCircle, 1.0), subRadius, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }
            }

            if ((kzTime >= waveTime0) && (kzTime <= waveTime1)) {
                tempColor = drawWave(waveR, 1.0);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }

            }
        }
    } else {
        //Update display power value
        float powerTime0 = 8.5;
        float powerTime1 = 9.1;
        float powerTime2 = 13.0;
        float powerTime3 = 14.1;

        PieRate = 0.0;
        currentPowerInAngle = 0.0;
        float displayPowerValue = POWER_RANGE_TO_NAVIGATE;

        if ((kzTime >= powerTime0) &&  (kzTime <= powerTime3)) {
            if (kzTime <= powerTime1) {
                displayPowerValue = (POWER_MAX_RANGE2 - POWER_RANGE_TO_NAVIGATE) * (kzTime - powerTime0) / (powerTime1 - powerTime0);
            } else if (kzTime <= powerTime2) {
                displayPowerValue = POWER_MAX_RANGE2;
            } else if (kzTime <= powerTime3) {
                displayPowerValue = POWER_MAX_RANGE2 - (POWER_MAX_RANGE2 - currentPowerMeterValue) * (kzTime - powerTime2) / (powerTime3 - powerTime2);
            }
        }
        if (kzTime >= powerTime3) {
            displayPowerValue = currentPowerMeterValue;
        }
        currentPowerInAngle = convertPowerToAngle(displayPowerValue, (225.0 - 1.6));
        float variantBorderWidth = SMALLEST_INNER_CIRCLE_RADIUS;
        if (angleOfCurrentPoint <= (maxAngleRange)) {
            float bigBorderShowTime0 = 3.5;
            float bigBorderShowTime1 = 4.35;

            float bigBorderHideTime0 = 14.7;
            float bigBorderHideTime1 = 15.2;
            vec4 greenShowColor = vec4(0.10980392156862745, 0.7254901960784313, 0.9098039215686274, 1.0);
            vec4 bigBorderColor = LAUNCH_CONTROL_CIRCLE_COLOR;
            if ((kzTime >= bigBorderShowTime0) && (kzTime <= bigBorderShowTime1)) {
                bigBorderColor = getGradientColor(LAUNCH_CONTROL_CIRCLE_COLOR, greenShowColor,(kzTime - bigBorderShowTime0) /(bigBorderShowTime1 - bigBorderShowTime0));
            }

            if ((kzTime > bigBorderShowTime1) && (kzTime < bigBorderHideTime0)) {
                bigBorderColor = greenShowColor;
            }

            if ((kzTime >= bigBorderHideTime0) && (kzTime <= bigBorderHideTime1)) {
                bigBorderColor = getGradientColor(greenShowColor, LAUNCH_CONTROL_CIRCLE_COLOR,(kzTime - bigBorderHideTime0) /(bigBorderHideTime1 - bigBorderHideTime0));
            }

            vec4 tempColor = drawSmothCircle(LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, bigBorderColor, LAUNCH_CONTROL_CIRCLE_RADIUS, centerPoint);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
                //
            }


            tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, POWER_BASE_CIRCLE_COLOR, POWER_CIRCLE_RADIUS, centerPoint);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }

            if ((angleOfCurrentPoint <= currentPowerInAngle) && (currentPowerMeterValue >= POWER_RANGE_TO_NAVIGATE)) {
                tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, POWER_CIRCLE_BORDER_COLOR, POWER_CIRCLE_RADIUS, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }

                tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, POWER_CIRCLE_GRADIENT_COLOR, POWER_CIRCLE_RADIUS, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }

                if ((y > (oy + 0.0028011204481793)) || (x > ox)) {
                    tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH - POWER_CIRCLE_BORDER_WIDTH * 2.0, POWER_CIRCLE_GRADIENT_COLOR, POWER_CIRCLE_RADIUS - POWER_CIRCLE_BORDER_WIDTH, centerPoint);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }


                    vec4 gradientColor = getGradientColor(vec4(vec3(0.0), 1.0), POWER_CIRCLE_GRADIENT_COLOR, angleOfCurrentPoint/currentPowerInAngle);
                    tempColor = drawSmothCircleWithSmoothColor(POWER_BASE_CIRCLE_WIDTH - POWER_CIRCLE_BORDER_WIDTH * 2.0, gradientColor, POWER_CIRCLE_RADIUS - POWER_CIRCLE_BORDER_WIDTH, centerPoint, POWER_CIRCLE_GRADIENT_COLOR);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }
                }

            }
        }

        //drawLineForCircle
        tempColor = drawLineForCircle(currentPowerInAngle, POWER_CIRCLE_RADIUS, POWER_BASE_CIRCLE_WIDTH, centerPoint, -POWER_INDICATOR_WHITE_WIDTH, vec4(1.0), true);
        if (!isBackgroundColor(tempColor)) {
            retColor = tempColor;
        }


        float showLowerTime0 = 3.9;
        float showLowerTime1 = 5.2;
        float showLowerTime2 = 5.6;

        float hideLowerTime0 = 13.8;
        float hideLowerTime1 = 13.3;
        float hideLowerTime2 = 14.8;
        float showAngle = 180.0;
        float showR = 0.0;
        vec4 greenShowColor = vec4(0.10980392156862745, 0.7254901960784313, 0.9098039215686274, 1.0);
        if (y < (oy - POWER_INDICATOR_WHITE_WIDTH)) {
            if (((angleOfCurrentPoint > 180.0) && (angleOfCurrentPoint < 225.0)) ||
                ((angleOfCurrentPoint > 240.0) && (angleOfCurrentPoint < 300.0)) ||
                ((angleOfCurrentPoint > 315.0) && (angleOfCurrentPoint < 360.0))) {
                vec4 tempColor = drawSmothCircle(LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, LAUNCH_CONTROL_CIRCLE_COLOR, LAUNCH_CONTROL_CIRCLE_RADIUS, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }

                if ((kzTime >= showLowerTime0) && (kzTime <= hideLowerTime2)) {

                    if (kzTime < showLowerTime1) {
                        showAngle = 180.0 + (225.0 - 180.0)/(showLowerTime1 - showLowerTime0);
                    } else if (kzTime < showLowerTime2) {
                        showAngle = 225.0;
                        showR =  POWER_BASE_CIRCLE_WIDTH * 2.0 * (kzTime - showLowerTime1) / (showLowerTime2 - showLowerTime1);
                    } else if (kzTime < hideLowerTime0) {
                        showAngle = 225.0;
                        showR = POWER_BASE_CIRCLE_WIDTH * 2.0;
                    } else if (kzTime < hideLowerTime1) {
                        showAngle = 225.0;
                        showR = POWER_BASE_CIRCLE_WIDTH * 2.0 * (1.0 - (kzTime - showLowerTime1) / (showLowerTime2 - showLowerTime1));
                    } else if (kzTime < hideLowerTime2) {
                        showAngle = 225.0 - (225.0 - 180.0)/(hideLowerTime2 - hideLowerTime1);
                        showR = 0.0;
                    }

                    if (angleOfCurrentPoint <= showAngle) {
                        vec4 tempColor = drawSmothCircle(LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, greenShowColor, LAUNCH_CONTROL_CIRCLE_RADIUS, centerPoint);
                        if (!isBackgroundColor(tempColor)) {
                            retColor = tempColor;
                        }
                    }
                }
            }

            //drawLineForCircle
            tempColor = drawLineForCircle(315.0, LAUNCH_CONTROL_CIRCLE_RADIUS, RANGE_LINE_BORDER_WIDTH, centerPoint, LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, LAUNCH_CONTROL_CIRCLE_COLOR, false);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }

            //drawLineForCircle
            tempColor = drawLineForCircle(225.0, LAUNCH_CONTROL_CIRCLE_RADIUS, RANGE_LINE_BORDER_WIDTH, centerPoint, -LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, LAUNCH_CONTROL_CIRCLE_COLOR, false);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }

            if ((kzTime >= showLowerTime0) && (kzTime <= hideLowerTime2)) {
                if (showR > 0.0) {
                    //drawLineForCircle
                    tempColor = drawLineForCircle(225.0, LAUNCH_CONTROL_CIRCLE_RADIUS, showR, centerPoint, -LAUNCH_CONTROL_CIRCLE_BORDER_WIDTH, greenShowColor, false);
                    if (!isBackgroundColor(tempColor)) {
                        retColor = tempColor;
                    }
                }
            }
        }

        if (currentPowerMeterValue < POWER_RANGE_TO_NAVIGATE) {
            if ((angleOfCurrentPoint <= 358.5348529411765) && (angleOfCurrentPoint >= currentPowerInAngle)) {
                tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, POWER_CIRCLE_BORDER_COLOR, POWER_CIRCLE_RADIUS, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }

                tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH, INNER_CIRCLE_CHARGED_GRADIENT_BEGIN, POWER_CIRCLE_RADIUS, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }



                tempColor = drawSmothCircle(POWER_BASE_CIRCLE_WIDTH - POWER_CIRCLE_BORDER_WIDTH * 2.0, INNER_CIRCLE_CHARGED_GRADIENT_BEGIN, POWER_CIRCLE_RADIUS - POWER_CIRCLE_BORDER_WIDTH, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }

                vec4 gradientColor = getGradientColor(INNER_CIRCLE_CHARGED_GRADIENT_BEGIN, INNER_CIRCLE_CHARGED_GRADIENT_END, 1.0 - (358.5 - angleOfCurrentPoint)/ 40.0);
                tempColor = drawSmothCircleWithSmoothColor(POWER_BASE_CIRCLE_WIDTH - POWER_CIRCLE_BORDER_WIDTH * 2.0, gradientColor, POWER_CIRCLE_RADIUS - POWER_CIRCLE_BORDER_WIDTH, centerPoint, POWER_CIRCLE_GRADIENT_COLOR);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }

                //drawLineForCircle
                tempColor = drawLineForCircle(358.5348529411765, POWER_CIRCLE_RADIUS, POWER_BASE_CIRCLE_WIDTH, centerPoint, -POWER_INDICATOR_WHITE_WIDTH, INNER_CIRCLE_CHARGED_GRADIENT_BEGIN, false);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }


                //drawLineForCircle
                tempColor = drawLineForCircle(currentPowerInAngle, POWER_CIRCLE_RADIUS, POWER_BASE_CIRCLE_WIDTH, centerPoint, -POWER_INDICATOR_WHITE_WIDTH, vec4(1.0), false);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }
            }
        }

        if (currentPowerMeterValue == POWER_RANGE_TO_NAVIGATE) {
            //drawLineForCircle
            tempColor = drawLineForCircle(360.0, POWER_CIRCLE_RADIUS, POWER_BASE_CIRCLE_WIDTH, centerPoint, -POWER_INDICATOR_WHITE_WIDTH, vec4(1.0), false);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor; //
            }
        }

        for (float i = 0.0; i < NUMBER_OF_INNER_CIRCLE; i += 1.0) {
            float subBorderWidth = SMALLEST_INNER_CIRCLE_BORDER_WIDTH;
            vec4 gradientColor = SMALLEST_INNER_CIRCLE_BORDER_COLOR;
            float subRadius = SMALLEST_INNER_CIRCLE_RADIUS + i*INNER_CIRCLE_DISTANCE;
            ////
            if (i > 0.0) {
                subBorderWidth = INNER_CIRCLE_BORDER_WIDTH;
                float pointPercent = 0.0;
                tempColor = drawSmothCircle(subBorderWidth, INNER_CIRCLE_NORMAL_GRADIENT_BEGIN, subRadius, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }


            }

        }

        float hideCircleTime0 = 11.0;
        float hideCircleTime1 = 14.0;

        // Smallest circle
        float alphaForSmallestCircle = 0.0;
        float smallestTime0 = 3.4;
        float smallestTime1 = 3.5;
        if (kzTime <= smallestTime0) {
            alphaForSmallestCircle = 0.0;
        } else if (kzTime <= smallestTime1) {
            alphaForSmallestCircle = 1.0 /(smallestTime1 - smallestTime0) * (kzTime - smallestTime0);
        } else if (kzTime <= hideCircleTime0){
            alphaForSmallestCircle = 1.0;
        } else if (kzTime <= hideCircleTime1){
            alphaForSmallestCircle = 1.0 - 1.0 /(hideCircleTime1 - hideCircleTime0) * (kzTime - hideCircleTime0);
        }

        float variationTime0 = 3.5;
        float variationTime1 = 4.3;
        float variationTime2 = 8.5;
        float variationTime3 = 9.4;//


        if ((kzTime >= variationTime0) && (kzTime <= variationTime3)){

            if (kzTime < variationTime1) {
                variantBorderWidth = SMALLEST_INNER_CIRCLE_RADIUS
                    + (kzTime - variationTime0)*(1.0*INNER_CIRCLE_DISTANCE)/(variationTime1 - variationTime0);
            } else if (kzTime < variationTime2) {
                variantBorderWidth = SMALLEST_INNER_CIRCLE_RADIUS + 1.5*INNER_CIRCLE_DISTANCE
                    - (kzTime - variationTime1)*(1.0*INNER_CIRCLE_DISTANCE)/(variationTime2 - variationTime1);
            } else if (kzTime < variationTime3) {
                variantBorderWidth = SMALLEST_INNER_CIRCLE_RADIUS
                    + (kzTime - variationTime2)*(12.0*INNER_CIRCLE_DISTANCE)/(variationTime3 - variationTime2);
            }

            tempColor = vec4(paintCircle(currentPoint, vec2(0.5), variantBorderWidth, 0.002), 1.0);
                if (!isBackgroundColor(tempColor)) {
                    retColor = vec4(tempColor.xyz * POWER_CIRCLE_GRADIENT_COLOR.xyz, 1.0);
                }
        }

        float subRadius = SMALLEST_INNER_CIRCLE_RADIUS;
        float subBorderWidth = SMALLEST_INNER_CIRCLE_BORDER_WIDTH;
        vec4 gradientColor = getGradientColor(SMALLEST_INNER_CIRCLE_BORDER_COLOR, POWER_CIRCLE_GRADIENT_COLOR, alphaForSmallestCircle);
        tempColor = drawSmothCircle(subBorderWidth, gradientColor, subRadius, centerPoint);
        if (!isBackgroundColor(tempColor)) {
            retColor = tempColor;
        }



        //

        if ((kzTime <=hideCircleTime0)) {
            float currentVariantIndex = (variantBorderWidth - SMALLEST_INNER_CIRCLE_RADIUS) / INNER_CIRCLE_DISTANCE;
            if (kzTime >= variationTime3) {
                currentVariantIndex = 12.0;
                variantBorderWidth = SMALLEST_INNER_CIRCLE_RADIUS + 12.0 * INNER_CIRCLE_DISTANCE;
            }


            // if ((currentVariantIndex >= 4.0) ) {
            //     tempColor = drawSmothCircle(INNER_CIRCLE_BORDER_WIDTH, POWER_CIRCLE_GRADIENT_COLOR, SMALLEST_INNER_CIRCLE_RADIUS + INNER_CIRCLE_DISTANCE*4.0, centerPoint);
            //     if (!isBackgroundColor(tempColor)) {
            //         retColor = tempColor;
            //     }
            // }
            //
            // if ((currentVariantIndex >= 8.0) ) {
            //     tempColor = drawSmothCircle(INNER_CIRCLE_BORDER_WIDTH, POWER_CIRCLE_GRADIENT_COLOR, SMALLEST_INNER_CIRCLE_RADIUS + INNER_CIRCLE_DISTANCE*8.0, centerPoint);
            //     if (!isBackgroundColor(tempColor)) {
            //         retColor = tempColor;
            //     }
            // }
        }

        else if ((kzTime <= hideCircleTime1)) {
            variantBorderWidth = SMALLEST_INNER_CIRCLE_RADIUS + 11.0*INNER_CIRCLE_DISTANCE
                - (kzTime - hideCircleTime0)*(12.0*INNER_CIRCLE_DISTANCE)/(hideCircleTime1 - hideCircleTime0);

            // float currentVariantIndex = (variantBorderWidth - SMALLEST_INNER_CIRCLE_RADIUS) / INNER_CIRCLE_DISTANCE;
            // if ((currentVariantIndex >= 4.0) ) {
            //     tempColor = drawSmothCircle(INNER_CIRCLE_BORDER_WIDTH, POWER_CIRCLE_GRADIENT_COLOR, SMALLEST_INNER_CIRCLE_RADIUS + INNER_CIRCLE_DISTANCE*4.0, centerPoint);
            //     if (!isBackgroundColor(tempColor)) {
            //         retColor = tempColor;
            //     }
            // }
            //
            // if ((currentVariantIndex >= 8.0) ) {
            //
            //     tempColor = drawSmothCircle(INNER_CIRCLE_BORDER_WIDTH, POWER_CIRCLE_GRADIENT_COLOR, SMALLEST_INNER_CIRCLE_RADIUS + INNER_CIRCLE_DISTANCE*8.0, centerPoint);
            //     if (!isBackgroundColor(tempColor)) {
            //         retColor = tempColor;
            //     }
            // }
        }
        float alpha4 = 0.0;
        float alpha8 = 0.0;
        float alphaRange = 2.0 * INNER_CIRCLE_DISTANCE;
        float deltaAlpha4 = variantBorderWidth - (SMALLEST_INNER_CIRCLE_RADIUS + 4.0 * INNER_CIRCLE_DISTANCE);
        if (deltaAlpha4 <= 0.0) {
            alpha4 = 1.0 + deltaAlpha4/alphaRange;
        } else {
            alpha4 = deltaAlpha4/alphaRange;
        }

        float deltaAlpha8 = variantBorderWidth - (SMALLEST_INNER_CIRCLE_RADIUS + 8.0 * INNER_CIRCLE_DISTANCE);
        if (deltaAlpha8 <= 0.0) {
            alpha8 = 1.0 + deltaAlpha8/alphaRange;
        } else {
            alpha8 = deltaAlpha8/alphaRange;
        }
        if (kzTime >= variationTime3) {
            alpha4 = 1.0;
            alpha8 = 1.0;
        }

        if ((kzTime <= hideCircleTime1) && (kzTime >=variationTime2)) {
            vec4 gradientColor = getGradientColor(SMALLEST_INNER_CIRCLE_BORDER_COLOR, POWER_CIRCLE_GRADIENT_COLOR, alpha4);
            tempColor = drawSmothCircle(INNER_CIRCLE_BORDER_WIDTH, gradientColor, SMALLEST_INNER_CIRCLE_RADIUS + INNER_CIRCLE_DISTANCE*4.0, centerPoint);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }

            gradientColor = getGradientColor(SMALLEST_INNER_CIRCLE_BORDER_COLOR, POWER_CIRCLE_GRADIENT_COLOR, alpha8);
            tempColor = drawSmothCircle(INNER_CIRCLE_BORDER_WIDTH, POWER_CIRCLE_GRADIENT_COLOR, SMALLEST_INNER_CIRCLE_RADIUS + INNER_CIRCLE_DISTANCE*8.0, centerPoint);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }
        }
    }

    /*
    tempColor = drawSmothCircle2(20.0/680.0, 300.0/680.0, centerPoint, 1.0);
    if (!isBackgroundColor(tempColor)) {
        retColor = tempColor;
    }
    */

    gl_FragColor = retColor;
}
