package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TrainingGroundRegistrationUnavailableLowGearScoreCommand extends TrainingGroundStatusDataModule
   {
      
      private static var _instance:TrainingGroundRegistrationUnavailableLowGearScoreCommand;
      
      public var gearScore:Number = 0;
      
      public function TrainingGroundRegistrationUnavailableLowGearScoreCommand(param1:Number = 0)
      {
         super();
         this.gearScore = param1;
      }
      
      public static function get instance() : TrainingGroundRegistrationUnavailableLowGearScoreCommand
      {
         return _instance || (_instance = new TrainingGroundRegistrationUnavailableLowGearScoreCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 22225;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.gearScore = param1.readFloat();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(22225);
         super.write(param1);
         param1.writeFloat(this.gearScore);
      }
   }
}

