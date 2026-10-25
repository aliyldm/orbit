package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingGroundStatusCommand implements IModule
   {
      
      private static var _instance:TrainingGroundStatusCommand;
      
      public static const TRAININGGROUNDSTATUSTYPE_REGISTRATION:int = 0;
      
      public static const TRAININGGROUNDSTATUSTYPE_REGISTRATION_UNAVAILABLE:int = 1;
      
      public static const TRAININGGROUNDSTATUSTYPE_LOOKING_FOR_OPPONENT:int = 2;
      
      public static const TRAININGGROUNDSTATUSTYPE_CONFIRMATION:int = 3;
      
      public static const TRAININGGROUNDSTATUSTYPE_PREPARING_FOR_FIGHT:int = 4;
      
      public static const TRAININGGROUNDSTATUSTYPE_FIGHT:int = 5;
      
      public static const TRAININGGROUNDSTATUSTYPE_SUMMING_UP:int = 6;
      
      public static const TRAININGGROUNDSTATUSTYPE_REGISTRATION_UNAVAILABLE_LOW_GEAR_SCORE:int = 7;
      
      public static const TRAININGGROUNDSTATUSTYPE__MAX:int = 8;
      
      public var statusType:int = 0;
      
      public var statusData:TrainingGroundStatusDataModule;
      
      public function TrainingGroundStatusCommand(param1:TrainingGroundStatusDataModule = null, param2:int = 0)
      {
         super();
         this.statusType = param2;
         if(param1 == null)
         {
            this.statusData = new TrainingGroundStatusDataModule();
         }
         else
         {
            this.statusData = param1;
         }
      }
      
      public static function get instance() : TrainingGroundStatusCommand
      {
         return _instance || (_instance = new TrainingGroundStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27320;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.statusType = param1.readShort();
         this.statusData = TrainingGroundStatusDataModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.statusData)
         {
            this.statusData.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27320);
         param1.writeShort(this.statusType);
         if(null != this.statusData)
         {
            this.statusData.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

