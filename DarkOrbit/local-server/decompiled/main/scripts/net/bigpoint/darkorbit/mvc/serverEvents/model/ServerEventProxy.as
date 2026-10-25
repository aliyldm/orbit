package net.bigpoint.darkorbit.mvc.serverEvents.model
{
   import net.bigpoint.darkorbit.com.module.EventModule;
   import net.bigpoint.darkorbit.com.module.EventUpdateCommand;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ServerEventProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "ServerEventProxy";
      
      public function ServerEventProxy()
      {
         super(NAME,new ServerEventModel());
      }
      
      public function get eventModel() : ServerEventModel
      {
         return data as ServerEventModel;
      }
      
      public function update(param1:EventUpdateCommand) : void
      {
         var _loc6_:EventModule = null;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc2_:Vector.<String> = this.eventModel.getAllActiveTypes();
         var _loc3_:Vector.<EventModule> = param1.activeCommands;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_.timeLeft > 10 && this.languageCheck(_loc6_.lang))
            {
               this.eventModel.addEvent(_loc6_.type,_loc6_.timeLeft,_loc6_.id);
            }
            _loc7_ = _loc2_.indexOf(_loc6_.type);
            if(_loc7_ != -1)
            {
               _loc2_.splice(_loc7_,1);
            }
            _loc5_++;
         }
         _loc4_ = int(_loc2_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc8_ = _loc2_[_loc5_];
            this.eventModel.removeEvent(_loc8_);
            _loc5_++;
         }
      }
      
      private function languageCheck(param1:String) : Boolean
      {
         var _loc5_:String = null;
         if(param1 == "all")
         {
            return true;
         }
         var _loc2_:Array = param1.split(",");
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_].split("_")[0];
            if(_loc5_ == Settings.language)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
   }
}

