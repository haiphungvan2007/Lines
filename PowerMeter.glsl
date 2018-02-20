#ifdef GL_ES
precision mediump float;
#endif

#define BACKGROUND_COLOR vec4(0.0, 0.0, 0.0, 0.0);

#define NUMBER_OF_CIRCLE 10.0
#define SMALLEST_RADIUS 170.0
#define SMALLEST_BORDER_WIDTH 4.0
#define SUB_BORDER_WIDTH 2.0
#define SUB_RADIUS_DISTANCE 8.0

#define CIRCLE_COLOR0 vec4(0.1803921568627451, 0.1803921568627451, 0.1803921568627451, 1.0)
#define CIRCLE_BORDER_WIDTH0 6.0
#define CIRCLE_RADIUS0 350.0

//0x00253F;
#define BEGIN_GRADIENT1 vec4(0.0, 0.1450980392156863, 0.24705882352941178, 1.0)
//0x0099FF
#define END_GRADIENT1 vec4(0.0, 0.6, 1.0, 1.0)


#define CIRCLE_COLOR1 vec4(0.07450980392156863, 0.07450980392156863, 0.07450980392156863, 1.0)
#define CIRCLE_WIDTH1 18.0
#define CIRCLE_BORDER1 3.0
#define CIRCLE_RADIUS1 330.0
#define CIRCLE_BORDER_COLOR1 vec4(0.0, 0.6, 1.0, 1.0) //0x0099FF;


//0D0D0D
#define BEGIN_GRADIENT2 vec4(0.050980392156862744, 0.050980392156862744, 0.050980392156862744, 1.0)
//2E2E2E
#define END_GRADIENT2 vec4(0.1803921568627451, 0.1803921568627451, 0.1803921568627451, 1.0)



#define SMOOTH(r,R) (1.0-smoothstep(R-1.0,R+1.0, r))
#define M_PI 3.1415926535897932384626433832795



bool isBackgroundColor(vec4 inputColor) {
    vec4 v = BACKGROUND_COLOR;
    float dt = distance(inputColor.xyz, v.xyz);
    if (dt <= 0.0) {
        return true;
    }
    return false;
}

vec4 getGradientColor(vec4 fromColor, vec4 toColor, float percent) {
    float R = fromColor.r + (toColor.r - fromColor.r) * percent;
    float G = fromColor.g + (toColor.g - fromColor.g) * percent;
    float B = fromColor.b + (toColor.b - fromColor.b) * percent;

    return vec4(R, G, B, 1.0);
}


// vec4 drawSmothCircle(float borderWidth, vec4 borderColor, float radius, vec2 centerPoint) {
//     vec4 backgroupColor = BACKGROUND_COLOR;
//     vec2 currentPoint = gl_FragCoord.xy;
//     currentPoint -= centerPoint;
//
//     float distanceToCenterPoint =  sqrt(dot(currentPoint, currentPoint));
//     float t = 1.0 + smoothstep(radius, radius + borderWidth, distanceToCenterPoint)
//                     - smoothstep(radius- borderWidth, radius, distanceToCenterPoint);
//     return mix(borderColor, backgroupColor, t);
// }




// // in use
vec4 drawSmothCircle(float borderWidth, vec4 borderColor, float radius, vec2 centerPoint) {

    /*
    vec2 currentPoint = gl_FragCoord.xy;
    vec2 centerPoint = u_resolution.xy / 2.0;
    float r = length(currentPoint - centerPoint);
    float temp = SMOOTH(r-borderWidth/2.0,radius)-SMOOTH(r+borderWidth/2.0,radius);
    vec4 retVal = BACKGROUND_COLOR;
    if (temp > 0.0){
        retVal = borderColor;
    }
    */


    vec2 currentPoint = gl_FragCoord.xy;
    float r = length(currentPoint - centerPoint);
    vec4 retVal = BACKGROUND_COLOR;
    if ((r >= (radius - borderWidth)) && (r <=  radius)) {
        retVal = borderColor;
    }
    return retVal;

}





// vec4 drawSmothCircle(float borderWidth, vec4 borderColor, float radius, vec2 centerPoint) {
//     vec2 currentPoint = gl_FragCoord.xy;
//     vec2 d = currentPoint - centerPoint;
//     float r = sqrt( dot( d, d ) );
//     d = normalize(d);
//     float theta = 180.0*(atan(d.y,d.x)/M_PI);
//     float temp = smoothstep(2.0, 2.1, abs(mod(theta+2.0,45.0)-2.0)) *
//         mix( 0.5, 1.0, step(45.0, abs(mod(theta, 180.0)-90.0)) ) *
//         (SMOOTH(r-borderWidth/2.0,radius)-SMOOTH(r+borderWidth/2.0,radius));
//
//     if (temp > 0.0) {
//         return vec4(vec3(temp), 1.0);
//     }
//     return BACKGROUND_COLOR;
// }

float getAngleFromPoint(vec2 inputPoint) {
    float ox = u_resolution.x / 2.0;
    float oy = u_resolution.y / 2.0;
    float x = inputPoint.x;
    float y = inputPoint.y;

    float huyen = sqrt((ox - x) * (ox - x) + (oy - y) * (oy - y));
    float ke = ox - x;
    float retVal = 0.0;
    if (huyen == 0.0) {
        if (x > ox) {
            retVal = 180.0;
        } else {
            retVal = 360.0;
        }
    } else {
        float temp = degrees(acos(ke / huyen));
        if (y > oy) {
            retVal = temp;
        } else {
            retVal = 360.0 - temp;
        }

    }

    return retVal;
}

vec4 drawLineForCircle(float angle, float circleRadius, float circelBorderWidth, vec2 centerPoint, float lineWidth, vec4 lineColor) {
    vec2 currentPoint = gl_FragCoord.xy;
    float pointPowerAngle = getAngleFromPoint(currentPoint);
    float distanceToCenter = length(currentPoint - centerPoint);

    vec4 retVal = BACKGROUND_COLOR;
    if (lineWidth < 0.0) {
        if (pointPowerAngle <= angle) {
            float deltaAngle = angle - pointPowerAngle;
            if (deltaAngle < 30.0) {
                float distanceToLine = sin(radians(deltaAngle)) * distanceToCenter;
                if (distanceToLine <= abs(lineWidth)) {
                    retVal = drawSmothCircle(circelBorderWidth, lineColor, circleRadius, centerPoint);
                }
            }
        }
    } else {
        if (pointPowerAngle >= angle) {
            float deltaAngle = pointPowerAngle - angle;
            if (deltaAngle < 30.0) {
                float distanceToLine = sin(radians(deltaAngle)) * distanceToCenter;
                if (distanceToLine <= abs(lineWidth)) {
                    retVal = drawSmothCircle(circelBorderWidth, lineColor, circleRadius, centerPoint);
                }
            }
        }
    }

    return retVal;
}


float variation(vec2 v1, vec2 v2, float strength, float speed) {
	return sin(
        dot(v1, v2) * strength + u_time * speed
    ) / 90.0;
}

vec3 paintCircle (vec2 uv, vec2 center, float rad, float width) {

    vec2 diff = center-uv;
    float len = length(diff);

    len += variation(diff, vec2(0.0, 1.0), 30.0, 20.0);
    len -= variation(diff, vec2(1.0, 0.0), 30.0, 20.0);

    float circle = smoothstep(rad-width, rad, len) - smoothstep(rad, rad+width, len);
    return vec3(circle);
}

void main() {
    vec4 retColor = BACKGROUND_COLOR;
    float currentPowerInPercent = 0.7;
    float x = gl_FragCoord.x;
    float y = gl_FragCoord.y;
    float ox = u_resolution.x / 2.0;
    float oy = u_resolution.y / 2.0;
    vec2 currentPoint = gl_FragCoord.xy;
    vec2 centerPoint = u_resolution.xy / 2.0;
    float distanceFragCoord = (ox - x) * (ox - x) + (oy - y) * (oy - y);

    vec4 tempColor = BACKGROUND_COLOR;

    float distanceToCenter = length(currentPoint - centerPoint);
    float pointPowerAngle = getAngleFromPoint(vec2(x, y));
    float pointPowerPercent = pointPowerAngle / 180.0;
    float currentPowerInAngle = currentPowerInPercent * 180.0;
    if (y >= oy) {
        vec4 tempColor = drawSmothCircle(CIRCLE_BORDER_WIDTH0, CIRCLE_COLOR0, CIRCLE_RADIUS0, centerPoint);
        if (!isBackgroundColor(tempColor)) {
            retColor = tempColor;
        }


        tempColor = drawSmothCircle(CIRCLE_WIDTH1, CIRCLE_COLOR1, CIRCLE_RADIUS1, centerPoint);
        if (!isBackgroundColor(tempColor)) {
            retColor = tempColor;
        }

        if (pointPowerAngle <= currentPowerInAngle) {
            tempColor = drawSmothCircle(CIRCLE_WIDTH1, CIRCLE_BORDER_COLOR1, CIRCLE_RADIUS1, centerPoint);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }

            if (y > (oy + 2.0)) {
                //Draw gradient border
                vec4 newBeginColor = getGradientColor(BEGIN_GRADIENT1, END_GRADIENT1, 1.0 - currentPowerInPercent);
                vec4 gradientColor = getGradientColor(newBeginColor, END_GRADIENT1, pointPowerAngle/currentPowerInAngle);
                tempColor = drawSmothCircle(CIRCLE_WIDTH1 - CIRCLE_BORDER1 * 2.0, gradientColor, CIRCLE_RADIUS1 - CIRCLE_BORDER1, centerPoint);
                if (!isBackgroundColor(tempColor)) {
                    retColor = tempColor;
                }
            }
        }
    }
    //drawLineForCircle
    tempColor = drawLineForCircle(currentPowerInAngle, CIRCLE_RADIUS1, CIRCLE_WIDTH1, centerPoint, -5.0, vec4(1.0));
    if (!isBackgroundColor(tempColor)) {
        retColor = tempColor;
    }

    if (y < (oy - 5.0)) {
        if (((pointPowerAngle > 180.0) && (pointPowerAngle < 225.0)) ||
            ((pointPowerAngle > 240.0) && (pointPowerAngle < 300.0)) ||
            ((pointPowerAngle > 315.0) && (pointPowerAngle < 360.0))) {
            vec4 tempColor = drawSmothCircle(CIRCLE_BORDER_WIDTH0, CIRCLE_COLOR0, CIRCLE_RADIUS0, centerPoint);
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }
        }

        //drawLineForCircle
        tempColor = drawLineForCircle(315.0, CIRCLE_RADIUS0, CIRCLE_WIDTH1*2.0, centerPoint, 5.0, CIRCLE_COLOR0);
        if (!isBackgroundColor(tempColor)) {
            retColor = tempColor;
        }

        //drawLineForCircle
        tempColor = drawLineForCircle(225.0, CIRCLE_RADIUS0, CIRCLE_WIDTH1*2.0, centerPoint, -5.0, CIRCLE_COLOR0);
        if (!isBackgroundColor(tempColor)) {
            retColor = tempColor;
        }
    }

    for (float i = 0.0; i < NUMBER_OF_CIRCLE; i += 1.0) {
        float subBorderWidth = SMALLEST_BORDER_WIDTH;
        if (i > 0.0) {
            subBorderWidth = SUB_BORDER_WIDTH;
        }
        float subRadius = SMALLEST_RADIUS + i*SUB_RADIUS_DISTANCE;
        float pointPercent = 0.0;
        if (pointPowerAngle >= currentPowerInAngle) {
            pointPercent = (pointPowerAngle - currentPowerInAngle) / 360.0;
        } else {
            pointPercent = (360.0 - currentPowerInAngle + pointPowerAngle) / 360.0;
        }
        vec4 gradientColor = getGradientColor(BEGIN_GRADIENT2, END_GRADIENT2, pointPercent);
        tempColor = drawSmothCircle(subBorderWidth, gradientColor, subRadius, centerPoint);
        if (!isBackgroundColor(tempColor)) {
            retColor = tempColor;
        }

        float smallCircleRadius = (subBorderWidth + 1.0) / 2.0;
        if ((pointPowerAngle > currentPowerInAngle) &&
            (pointPowerAngle < (currentPowerInAngle + 0.27)) &&
            (distanceToCenter <= subRadius) &&
            (distanceToCenter >= (subRadius - subBorderWidth))) {
            tempColor = drawSmothCircle(smallCircleRadius, vec4(1.0), smallCircleRadius, vec2(x, y));
            if (!isBackgroundColor(tempColor)) {
                retColor = tempColor;
            }
        }
    }

    tempColor = vec4(paintCircle(gl_FragCoord.xy/u_resolution.xy, vec2(0.5), (SMALLEST_RADIUS + SUB_RADIUS_DISTANCE) / u_resolution.x, 0.001), 1.0);
    if (!isBackgroundColor(tempColor)) {
        retColor = vec4(tempColor.xyz * END_GRADIENT1.xyz, 1.0);
    }

    gl_FragColor = retColor;
}
