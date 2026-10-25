package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TabSpaceSearchMissionsData
   {
      
      private var _count:int = 0;
      
      public var _list:Vector.<TabSpaceSearchMissionsListVO> = new Vector.<TabSpaceSearchMissionsListVO>(0);
      
      public const changed:ISignal = new Signal();
      
      public function TabSpaceSearchMissionsData()
      {
         super();
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function get list() : Vector.<TabSpaceSearchMissionsListVO>
      {
         return this._list;
      }
      
      public function updateData(param1:Vector.<TabSpaceSearchMissionsListVO>) : void
      {
         this._list = param1;
         ++this._count;
         this.changed.dispatch();
      }
   }
}

