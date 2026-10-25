package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageLootCommand implements IModule
   {
      
      private static var _instance:UserMessageLootCommand;
      
      public var ids:Vector.<Number>;
      
      public function UserMessageLootCommand(param1:Vector.<Number> = null)
      {
         super();
         if(param1 == null)
         {
            this.ids = new Vector.<Number>();
         }
         else
         {
            this.ids = param1;
         }
      }
      
      public static function get instance() : UserMessageLootCommand
      {
         return _instance || (_instance = new UserMessageLootCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -5342;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.ids.length > 0)
         {
            this.ids.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.ids.push(param1.readDouble());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Number = NaN;
         param1.writeShort(-5342);
         param1.writeByte(this.ids.length);
         for each(_loc2_ in this.ids)
         {
            param1.writeDouble(_loc2_);
         }
      }
   }
}

