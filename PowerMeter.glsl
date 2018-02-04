#ifdef GL_ES
precision mediump float;
#endif

#define BACKGROUND_COLOR vec4(0.0, 0.0, 0.0, 0.0);

#define NUMBER_OF_CIRCLE 10.0
#define SMALLEST_RADIUS 170.0;
#define SMALLEST_BORDER_WIDTH 4.0
#define SUB_BORDER_WIDTH 2.0
#define SUB_RADIUS_DISTANCE
#define BEGIN_GRADIENT1 vec4(0.0, 0.1450980392156863, 0.24705882352941178, 1.0) //0x00253F;
#define END_GRADIENT1 vec4(0.0, 0.6, 1.0, 1.0) //0x0099FF;
#define CIRCLE_COLOR1 vec4(0.07450980392156863, 0.07450980392156863, 0.07450980392156863, 1.0)
#define CIRCLE_WIDTH1 16.0
#define CIRCLE_BORDER1 4.0
#define CIRCLE_RADIUS1 330.0
#define CIRCLE_BORDER_COLOR1 vec4(0.0, 0.6, 1.0, 1.0) //0x0099FF;

#define SMOOTH(r,R) (1.0-smoothstep(R-1.0,R+1.0, r))

vec4 getGradientColor(vec4 fromColor, vec4 toColor, float percent) {
    float R = fromColor.x + (toColor.x - fromColor.x) * percent;
    float G = fromColor.y + (toColor.y - fromColor.y) * percent;
    float B = fromColor.z + (toColor.z - fromColor.z) * percent;

    return vec4(R, G, B, 1.0);
}

vec4 drawSmothCircle(float borderWidth, vec4 borderColor, float radius) {
    // vec4 backgroupColor = BACKGROUND_COLOR;
    // vec2 centerPoint = u_resolution.xy / 2.0;
    // vec2 currentPoint = gl_FragCoord.xy;
    // currentPoint -= centerPoint;
    //
    // float distanceToCenterPoint =  sqrt(dot(currentPoint, currentPoint));
    // float t = 1.0 + smoothstep(radius, radius + borderWidth, distanceToCenterPoint)
    //                 - smoothstep(radius- borderWidth, radius, distanceToCenterPoint);
    // return mix(borderColor, backgroupColor,t);

    //float circle(vec2 uv, vec2 center, float radius, float width)
    vec2 currentPoint = gl_FragCoord.xy;
    vec2 centerPoint = u_resolution.xy / 2.0;
    float r = length(currentPoint - centerPoint);
    float temp = SMOOTH(r-borderWidth/2.0,radius)-SMOOTH(r+borderWidth/2.0,radius);
    vec4 retVal = BACKGROUND_COLOR;
    if (temp > 0.0){
        retVal = borderColor;
    }
    return retVal;
}

float getAngleFromPoint(vec2 inputPoint,float ox, float oy) {
    float x = inputPoint.x;
    float y = inputPoint.y;

    float huyen = sqrt((ox - x) * (ox - x) + (oy - y) * (oy - y));
    float ke = ox - x;//sqrt((x - ox) *(x - ox));
    float retVal = 0.0;
    if (huyen == 0.0) {
        retVal = 180.0;
    } else {
        retVal = degrees(acos(ke / huyen));
    }

    return retVal;
}

void main() {


    vec4 retColor = BACKGROUND_COLOR;
    float currentPowerInPercent = 0.4;
    float x = gl_FragCoord.x;
    float y = gl_FragCoord.y;
    float ox = u_resolution.x / 2.0;
    float oy = u_resolution.y / 2.0;
    float distanceFragCoord = (ox - x) * (ox - x) + (oy - y) * (oy - y);


    if (y >= oy) {
        vec4 tempColor = drawSmothCircle(CIRCLE_WIDTH1, CIRCLE_COLOR1, CIRCLE_RADIUS1);
        if (tempColor.w > 0.0) {
            retColor = tempColor;
        }

        float pointPowerAngle = getAngleFromPoint(vec2(x, y), ox, oy);
        float pointPowerPercent = pointPowerAngle / 180.0;
        float currentPowerInAngle = currentPowerInPercent * 180.0;
        if (pointPowerAngle <= currentPowerInAngle) {
            tempColor = drawSmothCircle(CIRCLE_WIDTH1, CIRCLE_BORDER_COLOR1, CIRCLE_RADIUS1);
            if (tempColor.w > 0.0) {
                retColor = tempColor;
            }

            if (y > (oy + 2.0)) {
                tempColor = drawSmothCircle(CIRCLE_WIDTH1 0 \, BEGIN_GRADIENT1, CIRCLE_RADIUS1 - CIRCLE_BORDER1);
                if (tempColor.w > 0.0) {
                    retColor = tempColor;
                }
            }

            // tempColor = drawSmothCircle(CIRCLE_BORDER1, CIRCLE_BORDER_COLOR1, CIRCLE_RADIUS1 + CIRCLE_BORDER1 * 2.0);
            // if (tempColor.w > 0.0) {
            //    retColor = tempColor;
            // }
            //
            // tempColor = drawSmothCircle(CIRCLE_BORDER1, CIRCLE_BORDER_COLOR1, CIRCLE_RADIUS1 - CIRCLE_BORDER1 * 2.0);
            // if (tempColor.w > 0.0) {
            //    retColor = tempColor;
            // }
        }

    }


    gl_FragColor = retColor;


}
