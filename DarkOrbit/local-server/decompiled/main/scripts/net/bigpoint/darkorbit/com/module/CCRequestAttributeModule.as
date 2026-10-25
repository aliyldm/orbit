package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CCRequestAttributeModule implements IModule
   {
      
      private static var _instance:CCRequestAttributeModule;
      
      public var name:String = "";
      
      public var value:CCValueModule;
      
      public var subAttributes:Vector.<CCRequestAttributeModule>;
      
      public function CCRequestAttributeModule(param1:Vector.<CCRequestAttributeModule> = null, param2:String = "", param3:CCValueModule = null)
      {
         super();
         this.name = param2;
         if(param3 == null)
         {
            this.value = new CCValueModule();
         }
         else
         {
            this.value = param3;
         }
         if(param1 == null)
         {
            this.subAttributes = new Vector.<CCRequestAttributeModule>();
         }
         else
         {
            this.subAttributes = param1;
         }
      }
      
      public static function get instance() : CCRequestAttributeModule
      {
         return _instance || (_instance = new CCRequestAttributeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -26445;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CCRequestAttributeModule = null;
         this.name = param1.readUTF();
         this.value = CCValueModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.value)
         {
            this.value.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.subAttributes.length > 0)
         {
            this.subAttributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CCRequestAttributeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.subAttributes.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CCRequestAttributeModule = null;
         param1.writeShort(-26445);
         param1.writeUTF(this.name);
         if(null != this.value)
         {
            this.value.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.subAttributes.length);
         for each(_loc2_ in this.subAttributes)
         {
            _loc2_.write(param1);
         }
      }
   }
}

