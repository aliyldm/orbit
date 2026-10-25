package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingArenaSeasonInfoCommand implements IModule
   {
      
      private static var _instance:TrainingArenaSeasonInfoCommand;
      
      public var reward:Vector.<TrainingArenaSeasonRewardEntryCommand>;
      
      public var seasonName:String = "";
      
      public var seasonDuration:Number = 0;
      
      public function TrainingArenaSeasonInfoCommand(param1:String = "", param2:Number = 0, param3:Vector.<TrainingArenaSeasonRewardEntryCommand> = null)
      {
         super();
         if(param3 == null)
         {
            this.reward = new Vector.<TrainingArenaSeasonRewardEntryCommand>();
         }
         else
         {
            this.reward = param3;
         }
         this.seasonName = param1;
         this.seasonDuration = param2;
      }
      
      public static function get instance() : TrainingArenaSeasonInfoCommand
      {
         return _instance || (_instance = new TrainingArenaSeasonInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19157;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TrainingArenaSeasonRewardEntryCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.reward.length > 0)
         {
            this.reward.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TrainingArenaSeasonRewardEntryCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.reward.push(_loc4_);
            _loc2_++;
         }
         this.seasonName = param1.readUTF();
         this.seasonDuration = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TrainingArenaSeasonRewardEntryCommand = null;
         param1.writeShort(19157);
         param1.writeByte(this.reward.length);
         for each(_loc2_ in this.reward)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.seasonName);
         param1.writeDouble(this.seasonDuration);
      }
   }
}

