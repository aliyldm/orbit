package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model
{
   import flash.events.EventDispatcher;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SpaceSearchRewardData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public var events:Vector.<SSEvent> = new Vector.<SSEvent>();
      
      public var planets:Vector.<SSPlanet> = new Vector.<SSPlanet>();
      
      public var rewards:Vector.<SSReward> = new Vector.<SSReward>();
      
      public function SpaceSearchRewardData()
      {
         super();
      }
   }
}

