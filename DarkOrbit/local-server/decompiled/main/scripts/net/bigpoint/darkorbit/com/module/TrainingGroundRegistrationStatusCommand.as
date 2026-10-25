package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TrainingGroundRegistrationStatusCommand extends TrainingGroundStatusDataModule
   {
      
      private static var _instance:TrainingGroundRegistrationStatusCommand;
      
      public var rank:TrainingArenaRankInfoCommand;
      
      public var season:TrainingArenaSeasonInfoCommand;
      
      public var performance:TrainingArenaPerformanceInfoCommand;
      
      public function TrainingGroundRegistrationStatusCommand(param1:TrainingArenaRankInfoCommand = null, param2:TrainingArenaPerformanceInfoCommand = null, param3:TrainingArenaSeasonInfoCommand = null)
      {
         super();
         if(param1 == null)
         {
            this.rank = new TrainingArenaRankInfoCommand();
         }
         else
         {
            this.rank = param1;
         }
         if(param3 == null)
         {
            this.season = new TrainingArenaSeasonInfoCommand();
         }
         else
         {
            this.season = param3;
         }
         if(param2 == null)
         {
            this.performance = new TrainingArenaPerformanceInfoCommand();
         }
         else
         {
            this.performance = param2;
         }
      }
      
      public static function get instance() : TrainingGroundRegistrationStatusCommand
      {
         return _instance || (_instance = new TrainingGroundRegistrationStatusCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 17842;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.rank = TrainingArenaRankInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rank)
         {
            this.rank.read(param1);
         }
         this.season = TrainingArenaSeasonInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.season)
         {
            this.season.read(param1);
         }
         this.performance = TrainingArenaPerformanceInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.performance)
         {
            this.performance.read(param1);
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(17842);
         super.write(param1);
         if(null != this.rank)
         {
            this.rank.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.season)
         {
            this.season.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.performance)
         {
            this.performance.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

