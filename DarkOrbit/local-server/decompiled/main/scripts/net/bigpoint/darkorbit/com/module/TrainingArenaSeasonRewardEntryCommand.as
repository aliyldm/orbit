package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingArenaSeasonRewardEntryCommand implements IModule
   {
      
      private static var _instance:TrainingArenaSeasonRewardEntryCommand;
      
      public var range:String = "";
      
      public var items:Vector.<RewardContentModule>;
      
      public function TrainingArenaSeasonRewardEntryCommand(param1:String = "", param2:Vector.<RewardContentModule> = null)
      {
         super();
         this.range = param1;
         if(param2 == null)
         {
            this.items = new Vector.<RewardContentModule>();
         }
         else
         {
            this.items = param2;
         }
      }
      
      public static function get instance() : TrainingArenaSeasonRewardEntryCommand
      {
         return _instance || (_instance = new TrainingArenaSeasonRewardEntryCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 29408;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardContentModule = null;
         this.range = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.items.length > 0)
         {
            this.items.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardContentModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.items.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardContentModule = null;
         param1.writeShort(29408);
         param1.writeUTF(this.range);
         param1.writeByte(this.items.length);
         for each(_loc2_ in this.items)
         {
            _loc2_.write(param1);
         }
      }
   }
}

