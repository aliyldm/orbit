package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TrainingGroundRegistrationUnavailableStatusCommand extends TrainingGroundStatusDataModule
   {
      
      private static var _instance:TrainingGroundRegistrationUnavailableStatusCommand;
      
      public static const REGISTRATIONUNAVAILABLETYPE_PVP_OR_GATE_MAP:int = 0;
      
      public static const REGISTRATIONUNAVAILABLETYPE_MAINTENANCE:int = 1;
      
      public static const REGISTRATIONUNAVAILABLETYPE_PREPARE_FOR_JACKPOT:int = 2;
      
      public static const REGISTRATIONUNAVAILABLETYPE__MAX:int = 3;
      
      public var type:int = 0;
      
      public function TrainingGroundRegistrationUnavailableStatusCommand(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : TrainingGroundRegistrationUnavailableStatusCommand
      {
         return _instance || (_instance = new TrainingGroundRegistrationUnavailableStatusCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -28196;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.type = param1.readShort();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-28196);
         super.write(param1);
         param1.writeShort(this.type);
      }
   }
}

