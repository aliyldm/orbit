package Infinicast.Client.Api.Paths
{
   import Infinicast.*;
   import Infinicast.Client.Api.*;
   import Infinicast.Client.Api.Errors.*;
   import Infinicast.Client.Api.Paths.Handler.*;
   import Infinicast.Client.Api.Paths.Handler.Lists.*;
   import Infinicast.Client.Api.Paths.Handler.Messages.*;
   import Infinicast.Client.Api.Paths.Handler.Objects.*;
   import Infinicast.Client.Api.Paths.Handler.Reminders.*;
   import Infinicast.Client.Api.Paths.Handler.Requests.*;
   import Infinicast.Client.Api.Paths.Options.*;
   import Infinicast.Client.Api.Paths.TaskObjects.*;
   import Infinicast.Client.Api.Query.*;
   import Infinicast.Client.Impl.*;
   import Infinicast.Client.Impl.Contexts.*;
   import Infinicast.Client.Impl.Helper.*;
   import Infinicast.Client.Impl.Messaging.*;
   import Infinicast.Client.Impl.Messaging.Handlers.*;
   import Infinicast.Client.Impl.Messaging.Receiver.*;
   import Infinicast.Client.Impl.Messaging.sender.*;
   import Infinicast.Client.Impl.ObjectState.*;
   import Infinicast.Client.Impl.PathAccess.*;
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class AtomicChange
   {
      
      private var namedQueryList:Vector.<AfinityNamedJsonDataQuery> = new Vector.<AfinityNamedJsonDataQuery>();
      
      private var atomicChangeList:Vector.<InternAtomicChange> = new Vector.<InternAtomicChange>();
      
      public function AtomicChange()
      {
         super();
      }
      
      private function _removeProperty(param1:String) : InternAtomicChange
      {
         var _loc2_:InternAtomicChange = new InternAtomicChange();
         _loc2_.type = 7;
         _loc2_.jsonProperty = param1;
         this.atomicChangeList.push(_loc2_);
         return _loc2_;
      }
      
      private function _addToSet(param1:String) : InternAtomicChange
      {
         var _loc2_:InternAtomicChange = new InternAtomicChange();
         _loc2_.type = 5;
         _loc2_.jsonProperty = param1;
         this.atomicChangeList.push(_loc2_);
         return _loc2_;
      }
      
      private function _removeFromSet(param1:String) : InternAtomicChange
      {
         var _loc2_:InternAtomicChange = new InternAtomicChange();
         _loc2_.type = 6;
         _loc2_.jsonProperty = param1;
         this.atomicChangeList.push(_loc2_);
         return _loc2_;
      }
      
      private function _addToArray(param1:String) : InternAtomicChange
      {
         var _loc2_:InternAtomicChange = new InternAtomicChange();
         _loc2_.type = 1;
         _loc2_.jsonProperty = param1;
         this.atomicChangeList.push(_loc2_);
         return _loc2_;
      }
      
      private function _removeFromArray(param1:String) : InternAtomicChange
      {
         var _loc2_:InternAtomicChange = new InternAtomicChange();
         _loc2_.type = 2;
         _loc2_.jsonProperty = param1;
         this.atomicChangeList.push(_loc2_);
         return _loc2_;
      }
      
      private function _setValue(param1:String) : InternAtomicChange
      {
         var _loc2_:InternAtomicChange = new InternAtomicChange();
         _loc2_.type = 0;
         _loc2_.jsonProperty = param1;
         this.atomicChangeList.push(_loc2_);
         return _loc2_;
      }
      
      private function _setValueIfEmpty(param1:String) : InternAtomicChange
      {
         var _loc2_:InternAtomicChange = new InternAtomicChange();
         _loc2_.type = 8;
         _loc2_.jsonProperty = param1;
         this.atomicChangeList.push(_loc2_);
         return _loc2_;
      }
      
      private function _incValue(param1:String) : InternAtomicChange
      {
         var _loc2_:InternAtomicChange = new InternAtomicChange();
         _loc2_.type = 3;
         _loc2_.jsonProperty = param1;
         this.atomicChangeList.push(_loc2_);
         return _loc2_;
      }
      
      private function _decValue(param1:String) : InternAtomicChange
      {
         var _loc2_:InternAtomicChange = new InternAtomicChange();
         _loc2_.type = 4;
         _loc2_.jsonProperty = param1;
         this.atomicChangeList.push(_loc2_);
         return _loc2_;
      }
      
      public function addToArray1(param1:String, param2:*) : AtomicChange
      {
         this._addToArray(param1).setData(param2);
         return this;
      }
      
      public function addToArray2(param1:String, param2:Vector.<Object>) : AtomicChange
      {
         this._addToArray(param1).setData(param2);
         return this;
      }
      
      public function addToArray3(param1:String, param2:String) : AtomicChange
      {
         this._addToArray(param1).setData(param2);
         return this;
      }
      
      public function addToArray4(param1:String, param2:Number) : AtomicChange
      {
         this._addToArray(param1).setData(param2);
         return this;
      }
      
      public function addToArray5(param1:String, param2:int) : AtomicChange
      {
         this._addToArray(param1).setData(param2);
         return this;
      }
      
      public function create() : AtomicChange
      {
         return new AtomicChange();
      }
      
      public function removeFromArray1(param1:String, param2:*) : AtomicChange
      {
         this._removeFromArray(param1).setData(param2);
         return this;
      }
      
      public function removeFromArray2(param1:String, param2:Vector.<Object>) : AtomicChange
      {
         this._removeFromArray(param1).setData(param2);
         return this;
      }
      
      public function removeFromArray3(param1:String, param2:String) : AtomicChange
      {
         this._removeFromArray(param1).setData(param2);
         return this;
      }
      
      public function removeFromArray4(param1:String, param2:Number) : AtomicChange
      {
         this._removeFromArray(param1).setData(param2);
         return this;
      }
      
      public function removeFromArray5(param1:String, param2:Number) : AtomicChange
      {
         this._removeFromArray(param1).setData(param2);
         return this;
      }
      
      public function removeFromArray6(param1:String, param2:int) : AtomicChange
      {
         this._removeFromArray(param1).setData(param2);
         return this;
      }
      
      public function addToSet1(param1:String, param2:*) : AtomicChange
      {
         this._addToSet(param1).setData(param2);
         return this;
      }
      
      public function addToSet2(param1:String, param2:Vector.<Object>) : AtomicChange
      {
         this._addToSet(param1).setData(param2);
         return this;
      }
      
      public function addToSet3(param1:String, param2:String) : AtomicChange
      {
         this._addToSet(param1).setData(param2);
         return this;
      }
      
      public function addToSet4(param1:String, param2:Number) : AtomicChange
      {
         this._addToSet(param1).setData(param2);
         return this;
      }
      
      public function addToSet5(param1:String, param2:Number) : AtomicChange
      {
         this._addToSet(param1).setData(param2);
         return this;
      }
      
      public function addToSet6(param1:String, param2:int) : AtomicChange
      {
         this._addToSet(param1).setData(param2);
         return this;
      }
      
      public function removeFromSet1(param1:String, param2:*) : AtomicChange
      {
         this._removeFromSet(param1).setData(param2);
         return this;
      }
      
      public function removeFromSet2(param1:String, param2:Vector.<Object>) : AtomicChange
      {
         this._removeFromSet(param1).setData(param2);
         return this;
      }
      
      public function removeFromSet3(param1:String, param2:String) : AtomicChange
      {
         this._removeFromSet(param1).setData(param2);
         return this;
      }
      
      public function removeFromSet4(param1:String, param2:Number) : AtomicChange
      {
         this._removeFromSet(param1).setData(param2);
         return this;
      }
      
      public function removeFromSet5(param1:String, param2:Number) : AtomicChange
      {
         this._removeFromSet(param1).setData(param2);
         return this;
      }
      
      public function removeFromSet6(param1:String, param2:int) : AtomicChange
      {
         this._removeFromSet(param1).setData(param2);
         return this;
      }
      
      public function removeProperty(param1:String) : AtomicChange
      {
         this._removeProperty(param1);
         return this;
      }
      
      public function setValue1(param1:String, param2:*) : AtomicChange
      {
         this._setValue(param1).setData(param2);
         return this;
      }
      
      public function setValue2(param1:String, param2:Vector.<Object>) : AtomicChange
      {
         this._setValue(param1).setData(param2);
         return this;
      }
      
      public function setValue3(param1:String, param2:String) : AtomicChange
      {
         this._setValue(param1).setData(param2);
         return this;
      }
      
      public function setValue4(param1:String, param2:Boolean) : AtomicChange
      {
         this._setValue(param1).setData(param2);
         return this;
      }
      
      public function setValue5(param1:String, param2:Number) : AtomicChange
      {
         this._setValue(param1).setData(param2);
         return this;
      }
      
      public function setValue6(param1:String, param2:int) : AtomicChange
      {
         this._setValue(param1).setData(param2);
         return this;
      }
      
      public function setValueIfEmpty1(param1:String, param2:*) : AtomicChange
      {
         this._setValueIfEmpty(param1).setData(param2);
         return this;
      }
      
      public function setValueIfEmpty2(param1:String, param2:Vector.<Object>) : AtomicChange
      {
         this._setValueIfEmpty(param1).setData(param2);
         return this;
      }
      
      public function setValueIfEmpty3(param1:String, param2:String) : AtomicChange
      {
         this._setValueIfEmpty(param1).setData(param2);
         return this;
      }
      
      public function setValueIfEmpty4(param1:String, param2:Boolean) : AtomicChange
      {
         this._setValueIfEmpty(param1).setData(param2);
         return this;
      }
      
      public function setValueIfEmpty5(param1:String, param2:Number) : AtomicChange
      {
         this._setValueIfEmpty(param1).setData(param2);
         return this;
      }
      
      public function setValueIfEmpty6(param1:String, param2:int) : AtomicChange
      {
         this._setValueIfEmpty(param1).setData(param2);
         return this;
      }
      
      public function incValue1(param1:String, param2:Number) : AtomicChange
      {
         this._incValue(param1).setData(param2);
         return this;
      }
      
      public function incValue2(param1:String, param2:Number) : AtomicChange
      {
         this._incValue(param1).setData(param2);
         return this;
      }
      
      public function incValue3(param1:String, param2:int) : AtomicChange
      {
         this._incValue(param1).setData(param2);
         return this;
      }
      
      public function incValue4(param1:String, param2:int) : AtomicChange
      {
         this._incValue(param1).setData(param2);
         return this;
      }
      
      public function decValue1(param1:String, param2:Number) : AtomicChange
      {
         this._decValue(param1).setData(param2);
         return this;
      }
      
      public function decValue2(param1:String, param2:Number) : AtomicChange
      {
         this._decValue(param1).setData(param2);
         return this;
      }
      
      public function decValue3(param1:String, param2:int) : AtomicChange
      {
         this._decValue(param1).setData(param2);
         return this;
      }
      
      public function decValue4(param1:String, param2:int) : AtomicChange
      {
         this._decValue(param1).setData(param2);
         return this;
      }
      
      public function setNamedCollectionQuery(param1:String, param2:ICDataQuery) : AtomicChange
      {
         var _loc3_:AfinityNamedJsonDataQuery = new AfinityNamedJsonDataQuery();
         _loc3_.name = param1;
         _loc3_.query = param2;
         this.namedQueryList.push(_loc3_);
         return this;
      }
      
      public function toJson() : Vector.<Object>
      {
         var _loc2_:InternAtomicChange = null;
         var _loc1_:Vector.<Object> = new Vector.<Object>();
         for each(_loc2_ in this.atomicChangeList)
         {
            _loc1_.push(_loc2_.toJson());
         }
         return _loc1_;
      }
      
      public function getNamedQueryJson() : Vector.<Object>
      {
         var _loc2_:AfinityNamedJsonDataQuery = null;
         var _loc3_:* = undefined;
         var _loc1_:Vector.<Object> = new Vector.<Object>();
         for each(_loc2_ in this.namedQueryList)
         {
            _loc3_ = new Object();
            _loc3_["name"] = _loc2_.name;
            _loc3_["query"] = _loc2_.query.toJson();
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
      
      public function hasNamedQueries() : Boolean
      {
         return this.namedQueryList != null && this.namedQueryList.length > 0;
      }
      
      public function addToArray(param1:*, param2:*) : AtomicChange
      {
         if(param1 is String && param2 is Object)
         {
            return this.addToArray1(String(param1),param2);
         }
         if(param1 is String && param2 is Vector.<Object>)
         {
            return this.addToArray2(String(param1),Vector.<Object>(param2));
         }
         if(param1 is String && param2 is String)
         {
            return this.addToArray3(String(param1),String(param2));
         }
         if(param1 is String && param2 is Number)
         {
            return this.addToArray4(String(param1),Number(param2));
         }
         if(param1 is String && param2 is int)
         {
            return this.addToArray5(String(param1),int(param2));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      public function removeFromArray(param1:*, param2:*) : AtomicChange
      {
         if(param1 is String && param2 is Object)
         {
            return this.removeFromArray1(String(param1),param2);
         }
         if(param1 is String && param2 is Vector.<Object>)
         {
            return this.removeFromArray2(String(param1),Vector.<Object>(param2));
         }
         if(param1 is String && param2 is String)
         {
            return this.removeFromArray3(String(param1),String(param2));
         }
         if(param1 is String && param2 is Number)
         {
            return this.removeFromArray4(String(param1),Number(param2));
         }
         if(param1 is String && param2 is Number)
         {
            return this.removeFromArray5(String(param1),Number(param2));
         }
         if(param1 is String && param2 is int)
         {
            return this.removeFromArray6(String(param1),int(param2));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      public function addToSet(param1:*, param2:*) : AtomicChange
      {
         if(param1 is String && param2 is Object)
         {
            return this.addToSet1(String(param1),param2);
         }
         if(param1 is String && param2 is Vector.<Object>)
         {
            return this.addToSet2(String(param1),Vector.<Object>(param2));
         }
         if(param1 is String && param2 is String)
         {
            return this.addToSet3(String(param1),String(param2));
         }
         if(param1 is String && param2 is Number)
         {
            return this.addToSet4(String(param1),Number(param2));
         }
         if(param1 is String && param2 is Number)
         {
            return this.addToSet5(String(param1),Number(param2));
         }
         if(param1 is String && param2 is int)
         {
            return this.addToSet6(String(param1),int(param2));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      public function removeFromSet(param1:*, param2:*) : AtomicChange
      {
         if(param1 is String && param2 is Object)
         {
            return this.removeFromSet1(String(param1),param2);
         }
         if(param1 is String && param2 is Vector.<Object>)
         {
            return this.removeFromSet2(String(param1),Vector.<Object>(param2));
         }
         if(param1 is String && param2 is String)
         {
            return this.removeFromSet3(String(param1),String(param2));
         }
         if(param1 is String && param2 is Number)
         {
            return this.removeFromSet4(String(param1),Number(param2));
         }
         if(param1 is String && param2 is Number)
         {
            return this.removeFromSet5(String(param1),Number(param2));
         }
         if(param1 is String && param2 is int)
         {
            return this.removeFromSet6(String(param1),int(param2));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      public function setValue(param1:*, param2:*) : AtomicChange
      {
         if(param1 is String && param2 is Object)
         {
            return this.setValue1(String(param1),param2);
         }
         if(param1 is String && param2 is Vector.<Object>)
         {
            return this.setValue2(String(param1),Vector.<Object>(param2));
         }
         if(param1 is String && param2 is String)
         {
            return this.setValue3(String(param1),String(param2));
         }
         if(param1 is String && param2 is Boolean)
         {
            return this.setValue4(String(param1),Boolean(param2));
         }
         if(param1 is String && param2 is Number)
         {
            return this.setValue5(String(param1),Number(param2));
         }
         if(param1 is String && param2 is int)
         {
            return this.setValue6(String(param1),int(param2));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      public function setValueIfEmpty(param1:*, param2:*) : AtomicChange
      {
         if(param1 is String && param2 is Object)
         {
            return this.setValueIfEmpty1(String(param1),param2);
         }
         if(param1 is String && param2 is Vector.<Object>)
         {
            return this.setValueIfEmpty2(String(param1),Vector.<Object>(param2));
         }
         if(param1 is String && param2 is String)
         {
            return this.setValueIfEmpty3(String(param1),String(param2));
         }
         if(param1 is String && param2 is Boolean)
         {
            return this.setValueIfEmpty4(String(param1),Boolean(param2));
         }
         if(param1 is String && param2 is Number)
         {
            return this.setValueIfEmpty5(String(param1),Number(param2));
         }
         if(param1 is String && param2 is int)
         {
            return this.setValueIfEmpty6(String(param1),int(param2));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      public function incValue(param1:*, param2:*) : AtomicChange
      {
         if(param1 is String && param2 is Number)
         {
            return this.incValue1(String(param1),Number(param2));
         }
         if(param1 is String && param2 is Number)
         {
            return this.incValue2(String(param1),Number(param2));
         }
         if(param1 is String && param2 is int)
         {
            return this.incValue3(String(param1),int(param2));
         }
         if(param1 is String && param2 is int)
         {
            return this.incValue4(String(param1),int(param2));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      public function decValue(param1:*, param2:*) : AtomicChange
      {
         if(param1 is String && param2 is Number)
         {
            return this.decValue1(String(param1),Number(param2));
         }
         if(param1 is String && param2 is Number)
         {
            return this.decValue2(String(param1),Number(param2));
         }
         if(param1 is String && param2 is int)
         {
            return this.decValue3(String(param1),int(param2));
         }
         if(param1 is String && param2 is int)
         {
            return this.decValue4(String(param1),int(param2));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
   }
}

