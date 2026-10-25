package net.bigpoint.darkorbit.mvc.application.model.vo
{
   import flash.utils.ByteArray;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   
   public class SystemManagerVO
   {
      
      private var _main:Main;
      
      private var _memory:ByteArray;
      
      public function SystemManagerVO(param1:StartupVO)
      {
         super();
         this._main = param1.main;
      }
      
      public function get screenManager() : ScreenManager
      {
         return this._main.screenManager;
      }
      
      public function get guiManager() : GuiManager
      {
         return this._main.guiManager;
      }
      
      public function get memory() : ByteArray
      {
         if(this._memory == null)
         {
            this._memory = new ByteArray();
         }
         return this._memory;
      }
   }
}

