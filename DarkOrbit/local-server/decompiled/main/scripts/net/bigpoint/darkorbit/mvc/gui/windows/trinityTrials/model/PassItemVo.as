package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model
{
   import net.bigpoint.darkorbit.com.module.porting.passevent.PassItemModule;
   
   public class PassItemVo
   {
      
      private var _normalItem:PassItemModule;
      
      private var _vipItem:PassItemModule;
      
      private var _index:int = 1;
      
      public function PassItemVo()
      {
         super();
      }
      
      public function get normalItem() : PassItemModule
      {
         return this._normalItem;
      }
      
      public function set normalItem(param1:PassItemModule) : void
      {
         this._normalItem = param1;
      }
      
      public function get vipItem() : PassItemModule
      {
         return this._vipItem;
      }
      
      public function set vipItem(param1:PassItemModule) : void
      {
         this._vipItem = param1;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
   }
}

