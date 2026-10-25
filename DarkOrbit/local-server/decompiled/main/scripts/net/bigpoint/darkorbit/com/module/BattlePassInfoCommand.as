package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattlePassInfoCommand implements IModule
   {
      
      private static var _instance:BattlePassInfoCommand;
      
      public var filename:String = "";
      
      public var statusCommand:BattlePassUpdateStatusCommand;
      
      public var battlePassQuestModuleList:Vector.<BattlePassQuestModule>;
      
      public function BattlePassInfoCommand(param1:BattlePassUpdateStatusCommand = null, param2:String = "", param3:Vector.<BattlePassQuestModule> = null)
      {
         super();
         this.filename = param2;
         if(param1 == null)
         {
            this.statusCommand = new BattlePassUpdateStatusCommand();
         }
         else
         {
            this.statusCommand = param1;
         }
         if(param3 == null)
         {
            this.battlePassQuestModuleList = new Vector.<BattlePassQuestModule>();
         }
         else
         {
            this.battlePassQuestModuleList = param3;
         }
      }
      
      public static function get instance() : BattlePassInfoCommand
      {
         return _instance || (_instance = new BattlePassInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -4678;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:BattlePassQuestModule = null;
         this.filename = param1.readUTF();
         this.statusCommand = BattlePassUpdateStatusCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.statusCommand)
         {
            this.statusCommand.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.battlePassQuestModuleList.length > 0)
         {
            this.battlePassQuestModuleList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = BattlePassQuestModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.battlePassQuestModuleList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:BattlePassQuestModule = null;
         param1.writeShort(-4678);
         param1.writeUTF(this.filename);
         if(null != this.statusCommand)
         {
            this.statusCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.battlePassQuestModuleList.length);
         for each(_loc2_ in this.battlePassQuestModuleList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

