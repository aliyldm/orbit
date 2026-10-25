package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CCommandRequest implements IModule
   {
      
      private static var _instance:CCommandRequest;
      
      public var attributes:Vector.<CCRequestAttributeModule>;
      
      public var name:String = "";
      
      public function CCommandRequest(param1:String = "", param2:Vector.<CCRequestAttributeModule> = null)
      {
         super();
         if(param2 == null)
         {
            this.attributes = new Vector.<CCRequestAttributeModule>();
         }
         else
         {
            this.attributes = param2;
         }
         this.name = param1;
      }
      
      public static function get instance() : CCommandRequest
      {
         return _instance || (_instance = new CCommandRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16209;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CCRequestAttributeModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.attributes.length > 0)
         {
            this.attributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CCRequestAttributeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.attributes.push(_loc4_);
            _loc2_++;
         }
         this.name = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CCRequestAttributeModule = null;
         param1.writeShort(-16209);
         param1.writeShort(this.attributes.length);
         for each(_loc2_ in this.attributes)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.name);
      }
   }
}

