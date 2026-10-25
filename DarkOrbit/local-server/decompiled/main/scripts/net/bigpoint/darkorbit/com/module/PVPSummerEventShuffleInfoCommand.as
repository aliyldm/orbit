package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PVPSummerEventShuffleInfoCommand implements IModule
   {
      
      private static var _instance:PVPSummerEventShuffleInfoCommand;
      
      public var timeToNextShuffle:Number = 0;
      
      public function PVPSummerEventShuffleInfoCommand(param1:Number = 0)
      {
         super();
         this.timeToNextShuffle = param1;
      }
      
      public static function get instance() : PVPSummerEventShuffleInfoCommand
      {
         return _instance || (_instance = new PVPSummerEventShuffleInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -5165;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timeToNextShuffle = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-5165);
         param1.writeDouble(this.timeToNextShuffle);
      }
   }
}

