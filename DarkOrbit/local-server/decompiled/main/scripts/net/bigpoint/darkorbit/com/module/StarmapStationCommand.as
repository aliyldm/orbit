package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class StarmapStationCommand implements IModule
   {
      
      private static var _instance:StarmapStationCommand;
      
      public var currentServerTimestamp:Number = 0;
      
      public var stations:Vector.<StarmapStationInfo>;
      
      public function StarmapStationCommand(param1:Number = 0, param2:Vector.<StarmapStationInfo> = null)
      {
         super();
         this.currentServerTimestamp = param1;
         if(param2 == null)
         {
            this.stations = new Vector.<StarmapStationInfo>();
         }
         else
         {
            this.stations = param2;
         }
      }
      
      public static function get instance() : StarmapStationCommand
      {
         return _instance || (_instance = new StarmapStationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1150;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:StarmapStationInfo = null;
         this.currentServerTimestamp = param1.readDouble();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.stations.length > 0)
         {
            this.stations.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = StarmapStationInfo(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.stations.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:StarmapStationInfo = null;
         param1.writeShort(1150);
         param1.writeDouble(this.currentServerTimestamp);
         param1.writeByte(this.stations.length);
         for each(_loc2_ in this.stations)
         {
            _loc2_.write(param1);
         }
      }
   }
}

