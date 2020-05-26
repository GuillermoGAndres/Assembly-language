xn = [0,2,3,4,7,8,9,10,12,15,18,20,17,14,13,11,9,6,4,2,1,0]
f = []

def hex(num):
    h = [0,1,2,3,4,5,6,7,8,9,'A','B','C','D','E','F']
    return h[num]

def convertirHexa(numero):
    hexa =""
    while(numero != 0):
        cociente = int(numero / 16) 
        hexa += str(hex(numero % 16))
        numero = cociente
    hexa = hexa[::-1]
    #print(hexa)
    return hexa

for x in xn:
    if( x <=5):
        f.append(x**2 + 3)
    elif( x <= 10):
        f.append(f[len(f)-1] - 2)
    else:
        f.append( (x/2) + 4*x -5 ) 

print("hexadecimal")
h = []
for numero in f:
    h.append(convertirHexa(int(numero)))

for i in range( len(xn) ):
    print("x: ",xn[i],"\tfn: ", f[i], "\tfnh: ", h[i])
   
