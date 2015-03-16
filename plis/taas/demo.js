$(document).ready(function () {
    var slides = [{
        "startDate": "2015,3,15",
            "headline": "R8.1 Production Deployment",
            "text": "PLIS Release 8.1 is CBS onboarding and post-Release 8 changes.",
            "tag": "Release"
    }, {
        "startDate": "2015,6",
            "headline": "R8.1.1 Production Deployment",
            "text": "PLIS Release 8.1.1 comprises changes based on legacy data.",
            "tag": "Release"
    }, {
        "startDate": "2015,12",
            "headline": "R9 Production Deployment",
            "text": "PLIS Release 9 comprises changes required for Software Transformation (SWT).",
            "tag": "Release"
    }, {
        "startDate": "2015,5",
            "headline": "Projected Disk-space Crossover",
            "text": "At current rate of growth, this is when we project that we will run out of space if we take no actions to mitigate."
        ,"tag": "Projection"
    }, {
        "startDate": "2015,8",
            "headline": "Projected Disk-space Crossover with Compression",
            "text": "At current rate of growth, this is when we project we will run out of space after MPL compression."
        ,"tag": "Projection"
    }, {
        "startDate": "2015,10",
            "headline": "Project Disk-space Crossover with P2",
            "text": "At current rate of growth, this is when we project we will run out of space after MPL compression and Phase 2 data model are deployed."
        ,"tag": "Projection"
    }, {
        "startDate": "2016,10",
            "headline": "Project Disk-space Crossover with P3",
            "text": "At current rate of growth, this is when we project we will run out of space after MPL compression, Phase 2 data model and Phase 3 background process are deployed."
        ,"tag": "Projection"
    }, {
        "startDate": "2015,4",
            "headline": "PLIS MPL Compression go-live",
            "text": "MPL Compression is the work Mark Sleath is carrying out with archive compression of PLIS MPL tables and indexes.",
            "tag": "Milestone"
    }, {
        "startDate": "2015,8",
            "headline": "PLIS Phase 2 go-live",
            "text": "PLIS P2 is a refactored data model for PLIS Administrative Entities, like Patient and Provider.",
            "tag": "Milestone"
    }, {
        "startDate": "2016,2",
            "headline": "PLIS Phase 3 go-live",
            "text": "PLIS P3 is a background process to transition existing Administrative Entity into the P2 data model.",
            "tag": "Milestone"
    }]

    var dataObject = {
        "timeline": {
            "headline": "Disk Usage Projections",
                "type": "default",
                "text": "For PLIS MPL Schema",
                "startDate": "2015,2,17",
                "date": slides           
/*                ,"era": [
                    {
                        "startDate":"2015,1",
                        "endDate":"2015,12",
                        "headline":"Milestone",
                        "text":"<p>Body text goes here, some HTML is OK</p>",
                        "tag":"Milestone"
                    }
                ] */
            
        }
    };

    createStoryJS({
        type: 'timeline',
        width: '100%',
        height: '500',
        source: dataObject,
        embed_id: 'my-timeline',
        start_zoom_adjust: 2
    });
});
