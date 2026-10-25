package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.model
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TabSpaceSearchRewardsData
   {
      
      public const changed:ISignal = new Signal();
      
      private var _count:int = 0;
      
      private var _list:Vector.<TabSpaceSearchRewardsListVO>;
      
      public function TabSpaceSearchRewardsData()
      {
         super();
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function get list() : Vector.<TabSpaceSearchRewardsListVO>
      {
         return this._list;
      }
      
      public function updateData(param1:Vector.<TabSpaceSearchRewardsListVO>) : void
      {
         this._list = param1;
         ++this._count;
         this.changed.dispatch();
      }
   }
}

