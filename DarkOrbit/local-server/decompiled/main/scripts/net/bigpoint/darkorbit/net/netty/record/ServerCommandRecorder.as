package net.bigpoint.darkorbit.net.netty.record
{
   import net.bigpoint.com.module.IModule;
   
   public class ServerCommandRecorder extends AbstractRecorder
   {
      
      public static const INSTANCE:ServerCommandRecorder = new ServerCommandRecorder();
      
      public static const serverCommandsBlackFilterList:Array = [];
      
      public function ServerCommandRecorder()
      {
         super();
      }
      
      public function record(param1:IModule) : void
      {
         var _loc2_:RecordVO = null;
         _loc2_ = new RecordVO();
         _loc2_.isCommand = true;
         super._record(param1,_loc2_);
      }
      
      override protected function get blackFilterList() : Array
      {
         return ServerCommandRecorder.serverCommandsBlackFilterList;
      }
      
      override protected function createOutput(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:RecordVO = null;
         param1 += "- SERVERCOMMANDS start --------------------------------------------------\n";
         for each(_loc3_ in records)
         {
            if(_loc3_.params.length > 0)
            {
               _loc2_ = "API.handleServerCommand(" + _loc3_.clazzname + "," + _loc3_.params + ");";
            }
            else
            {
               _loc2_ = "API.handleServerCommand(" + _loc3_.clazzname + ");";
            }
            param1 += _loc2_ + "\n";
         }
         return param1;
      }
   }
}

