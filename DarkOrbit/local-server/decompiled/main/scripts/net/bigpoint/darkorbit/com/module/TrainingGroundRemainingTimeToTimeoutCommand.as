package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingGroundRemainingTimeToTimeoutCommand implements IModule
   {
      
      private static var _instance:TrainingGroundRemainingTimeToTimeoutCommand;
      
      public var remainingMillisecondsToTimeout:int = 0;
      
      public function TrainingGroundRemainingTimeToTimeoutCommand(param1:int = 0)
      {
         super();
         this.remainingMillisecondsToTimeout = param1;
      }
      
      public static function get instance() : TrainingGroundRemainingTimeToTimeoutCommand
      {
         return _instance || (_instance = new TrainingGroundRemainingTimeToTimeoutCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -26058;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.remainingMillisecondsToTimeout = param1.readInt();
         this.remainingMillisecondsToTimeout = this.remainingMillisecondsToTimeout << 5 % 32 | this.remainingMillisecondsToTimeout >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-26058);
         param1.writeInt(this.remainingMillisecondsToTimeout >>> 5 % 32 | this.remainingMillisecondsToTimeout << 32 - 5 % 32);
      }
   }
}

