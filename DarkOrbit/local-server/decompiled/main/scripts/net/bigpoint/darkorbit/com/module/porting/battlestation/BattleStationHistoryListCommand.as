package net.bigpoint.darkorbit.com.module.porting.battlestation
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class BattleStationHistoryListCommand implements IModule
   {
      
      private static var _instance:BattleStationHistoryListCommand;
      
      public var commandList:Vector.<BattleStationHistoryInfoCommand>;
      
      public var startIndex:int = 0;
      
      public var total:int = 0;
      
      public function BattleStationHistoryListCommand(param1:int = 0, param2:int = 0, param3:Vector.<BattleStationHistoryInfoCommand> = null)
      {
         super();
         if(param3 == null)
         {
            this.commandList = new Vector.<BattleStationHistoryInfoCommand>();
         }
         else
         {
            this.commandList = param3;
         }
         this.startIndex = param2;
         this.total = param1;
      }
      
      public static function get instance() : BattleStationHistoryListCommand
      {
         return _instance || (_instance = new BattleStationHistoryListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12632;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:BattleStationHistoryInfoCommand = null;
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
            _loc4_ = BattleStationHistoryInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.commandList.push(_loc4_);
            _loc2_++;
         }
         this.startIndex = param1.readInt();
         this.startIndex = this.startIndex >>> 5 % 32 | this.startIndex << 32 - 5 % 32;
         this.total = param1.readInt();
         this.total = this.total << 11 % 32 | this.total >>> 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:BattleStationHistoryInfoCommand = null;
         param1.writeShort(-12632);
         param1.writeByte(this.commandList.length);
         for each(_loc2_ in this.commandList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.startIndex << 5 % 32 | this.startIndex >>> 32 - 5 % 32);
         param1.writeInt(this.total >>> 11 % 32 | this.total << 32 - 11 % 32);
      }
   }
}

