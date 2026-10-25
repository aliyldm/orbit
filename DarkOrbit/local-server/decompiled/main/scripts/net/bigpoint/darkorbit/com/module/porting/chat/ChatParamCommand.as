package net.bigpoint.darkorbit.com.module.porting.chat
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.*;
   
   public class ChatParamCommand implements IModule
   {
      
      private static var _instance:ChatParamCommand;
      
      public var moduleList:Vector.<TupleTwoModule>;
      
      public function ChatParamCommand(param1:Vector.<TupleTwoModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.moduleList = new Vector.<TupleTwoModule>();
         }
         else
         {
            this.moduleList = param1;
         }
      }
      
      public static function get instance() : ChatParamCommand
      {
         return _instance || (_instance = new ChatParamCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26607;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TupleTwoModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.moduleList.length > 0)
         {
            this.moduleList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TupleTwoModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.moduleList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TupleTwoModule = null;
         param1.writeShort(26607);
         param1.writeByte(this.moduleList.length);
         for each(_loc2_ in this.moduleList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

