package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MessageKeyListWildcardCommand implements IModule
   {
      
      private static var _instance:MessageKeyListWildcardCommand;
      
      public var commandList:Vector.<MessageKeyListWildcardModule>;
      
      public function MessageKeyListWildcardCommand(param1:Vector.<MessageKeyListWildcardModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.commandList = new Vector.<MessageKeyListWildcardModule>();
         }
         else
         {
            this.commandList = param1;
         }
      }
      
      public static function get instance() : MessageKeyListWildcardCommand
      {
         return _instance || (_instance = new MessageKeyListWildcardCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12768;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:MessageKeyListWildcardModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.commandList.length > 0)
         {
            this.commandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = MessageKeyListWildcardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.commandList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:MessageKeyListWildcardModule = null;
         param1.writeShort(-12768);
         param1.writeByte(this.commandList.length);
         for each(_loc2_ in this.commandList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

