package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyCollectAllRequest implements IModule
   {
      
      private static var _instance:AssemblyCollectAllRequest;
      
      public var allRequests:Vector.<AssemblyCollectRequest>;
      
      public function AssemblyCollectAllRequest(param1:Vector.<AssemblyCollectRequest> = null)
      {
         super();
         if(param1 == null)
         {
            this.allRequests = new Vector.<AssemblyCollectRequest>();
         }
         else
         {
            this.allRequests = param1;
         }
      }
      
      public static function get instance() : AssemblyCollectAllRequest
      {
         return _instance || (_instance = new AssemblyCollectAllRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 22374;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:AssemblyCollectRequest = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.allRequests.length > 0)
         {
            this.allRequests.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = AssemblyCollectRequest(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.allRequests.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:AssemblyCollectRequest = null;
         param1.writeShort(22374);
         param1.writeShort(this.allRequests.length);
         for each(_loc2_ in this.allRequests)
         {
            _loc2_.write(param1);
         }
      }
   }
}

