trigger EventSpeakerTrigger on EventSpeakers__c (before insert, before Update) 
{
    // Step 1 - Get the speaker id & event id 
	// Step 2 - SOQL on Event to get the Start Date and Put them into a Map
	// Step 3 - SOQL on Event - Spekaer to get the Related Speaker along with the Event Start Date
	// Step 4 - Check the Conditions and throw the Error
	
    //Step 1
    Set<Id> SpeakerIdSet = New Set<Id>();
    Set<Id> EventIdSet = New Set<Id>();
    
    For(EventSpeakers__c ESp : Trigger.New)
    {
        SpeakerIdSet.add(Esp.Speaker__c);
        EventIdSet.add(Esp.Event__c);
    }
    
    //Step 2
    Map<Id, DateTime> RequestedEvents = New Map<Id, DateTime>();
    
    List<Event__c> LstEvents =[Select Id, Start_DateTime__c From Event__c
                                                where Id IN :EventIdSet];
    
    For(Event__c Evt : LstEvents)
    {
        RequestedEvents.put(Evt.Id, Evt.Start_DateTime__c);
    }
    
    //Step 3
    List<EventSpeakers__c> LstEventSpeakers =[Select id,Event__c, Speaker__c, 
                                                    event__r.Start_DateTime__c 
                                                                 from EventSpeakers__c where Speaker__c IN : SpeakerIdSet];
    
    //Step 4
    For(EventSpeakers__c Es : Trigger.new)
    {
         DateTime BookingTime =  RequestedEvents.get(Es.Event__c);
        
        For(EventSpeakers__c Es1 :LstEventSpeakers)
        {
            If(Es1.Speaker__c == Es.Speaker__c &&  Es1.Event__r.Start_dateTime__c == BookingTime)
            {
                es.Speaker__c.addError('The Speaker Is Already Booked At That Time');
            }
        }
    }  
}