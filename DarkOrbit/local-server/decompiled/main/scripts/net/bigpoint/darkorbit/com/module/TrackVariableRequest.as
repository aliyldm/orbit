package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrackVariableRequest implements IModule
   {
      
      private static var _instance:TrackVariableRequest;
      
      public var data:Vector.<TrackVariableModule>;
      
      public function TrackVariableRequest(param1:Vector.<TrackVariableModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.data = new Vector.<TrackVariableModule>();
         }
         else
         {
            this.data = param1;
         }
      }
      
      public static function get instance() : TrackVariableRequest
      {
         return _instance || (_instance = new TrackVariableRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24553;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TrackVariableModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.data.length > 0)
         {
            this.data.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TrackVariableModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.data.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TrackVariableModule = null;
         param1.writeShort(-24553);
         param1.writeByte(this.data.length);
         for each(_loc2_ in this.data)
         {
            _loc2_.write(param1);
         }
      }
   }
}

