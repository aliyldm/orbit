package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.model
{
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.BoundPackage;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TabSpaceSearchRewardsListVO
   {
      
      public var nameStr:String;
      
      public var isSpecial:Boolean = false;
      
      public var range:int;
      
      public var count:int;
      
      public var unlock:Boolean;
      
      public var received:Boolean;
      
      public var bp:BoundPackage;
      
      public const requestExchange:ISignal = new Signal(TabSpaceSearchRewardsListVO);
      
      public function TabSpaceSearchRewardsListVO()
      {
         super();
      }
   }
}

