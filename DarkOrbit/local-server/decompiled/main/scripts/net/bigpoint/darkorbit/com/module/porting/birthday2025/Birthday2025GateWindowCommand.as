package net.bigpoint.darkorbit.com.module.porting.birthday2025
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class Birthday2025GateWindowCommand implements IModule
   {
      
      private static var _instance:Birthday2025GateWindowCommand;
      
      public var curLevel:int = 0;
      
      public var commandList:Vector.<Birthday2025GateRewardCommand>;
      
      public var curLootAmount:int = 0;
      
      public function Birthday2025GateWindowCommand(param1:int = 0, param2:int = 0, param3:Vector.<Birthday2025GateRewardCommand> = null)
      {
         super();
         this.curLevel = param1;
         if(param3 == null)
         {
            this.commandList = new Vector.<Birthday2025GateRewardCommand>();
         }
         else
         {
            this.commandList = param3;
         }
         this.curLootAmount = param2;
      }
      
      public static function get instance() : Birthday2025GateWindowCommand
      {
         return _instance || (_instance = new Birthday2025GateWindowCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31204;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:Birthday2025GateRewardCommand = null;
         this.curLevel = param1.readInt();
         this.curLevel = this.curLevel >>> 15 % 32 | this.curLevel << 32 - 15 % 32;
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
            _loc4_ = Birthday2025GateRewardCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.commandList.push(_loc4_);
            _loc2_++;
         }
         this.curLootAmount = param1.readInt();
         this.curLootAmount = this.curLootAmount << 5 % 32 | this.curLootAmount >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Birthday2025GateRewardCommand = null;
         param1.writeShort(-31204);
         param1.writeInt(this.curLevel << 15 % 32 | this.curLevel >>> 32 - 15 % 32);
         param1.writeByte(this.commandList.length);
         for each(_loc2_ in this.commandList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.curLootAmount >>> 5 % 32 | this.curLootAmount << 32 - 5 % 32);
      }
   }
}

