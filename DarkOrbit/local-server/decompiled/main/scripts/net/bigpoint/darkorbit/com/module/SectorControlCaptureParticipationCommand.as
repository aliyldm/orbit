package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlCaptureParticipationCommand implements IModule
   {
      
      private static var _instance:SectorControlCaptureParticipationCommand;
      
      public var sectorId:String = "";
      
      public var capturing:Boolean = false;
      
      public function SectorControlCaptureParticipationCommand(param1:String = "", param2:Boolean = false)
      {
         super();
         this.sectorId = param1;
         this.capturing = param2;
      }
      
      public static function get instance() : SectorControlCaptureParticipationCommand
      {
         return _instance || (_instance = new SectorControlCaptureParticipationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6678;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.sectorId = param1.readUTF();
         this.capturing = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6678);
         param1.writeUTF(this.sectorId);
         param1.writeBoolean(this.capturing);
      }
   }
}

